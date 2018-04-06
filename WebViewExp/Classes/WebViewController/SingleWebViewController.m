//
//  SingleWebViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/21.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "SingleWebViewController.h"
#import <WebKit/WebKit.h>
#import <KVOController/KVOController.h>

typedef void(^ControllerHandlerBlock)(void);

@interface SingleWebViewController ()<UISearchBarDelegate, UIWebViewDelegate, WKNavigationDelegate>

@property (nonatomic, copy) ControllerHandlerBlock viewDidLoadHandler;

@property (nonatomic, strong, readonly) UIWebView *uiWebView;
@property (nonatomic, weak, readonly) WKWebView *wkWebView;
@property (nonatomic, assign) BOOL fullscreen;

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIProgressView *loadingProgressView;
@property (nonatomic, weak) UIBarButtonItem *backButton;
@property (nonatomic, weak) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;

@property (nonatomic, assign) BOOL canGoBack;
@property (nonatomic, assign) BOOL canGoForward;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) CGFloat loadingProgress;

@end

@implementation SingleWebViewController

- (void)dealloc {
	NSLog(@"%s", __FUNCTION__);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (self.viewDidLoadHandler) {
		self.viewDidLoadHandler();
		self.viewDidLoadHandler = nil;
	}
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	
//	UISearchBar *searchBar = [[UISearchBar alloc] init];
//	searchBar.searchBarStyle = UISearchBarStyleMinimal;
//	searchBar.text = @"https://www.baidu.com";
//	searchBar.delegate = self;
//	self.navigationItem.titleView = searchBar;
	//self.navigationItem.hidesSearchBarWhenScrolling;
	
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
	return self.fullscreen;
}

- (void)setupUI {
	UIView *webView = self.webView;
	self.title = NSStringFromClass(webView.class);
	[self addToolBarButtons];
	self.view.backgroundColor = [UIColor whiteColor];
	// 布局 webView
	{
		[self.view addSubview:webView];
		webView.translatesAutoresizingMaskIntoConstraints = NO;
		id top = self.topLayoutGuide;
		id bottom = self.bottomLayoutGuide;
		NSDictionary *views = NSDictionaryOfVariableBindings(webView, top, bottom);
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:views]];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][webView][bottom]|" options:0 metrics:nil views:views]];
	}
	// 添加加载进度
	{
		UIProgressView *loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		[self.view addSubview:loadingProgress];
		loadingProgress.translatesAutoresizingMaskIntoConstraints = NO;
		id top = self.topLayoutGuide;
		NSDictionary *views = NSDictionaryOfVariableBindings(loadingProgress, top);
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loadingProgress]|" options:0 metrics:nil views:views]];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][loadingProgress]" options:0 metrics:nil views:views]];
		self.loadingProgressView = loadingProgress;
	}
}

- (void)addToolBarButtons {
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction:)];
	self.refreshButton = refreshButton;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
	backButton.enabled = NO;
	self.backButton = backButton;
	
	UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction:)];
	forwardButton.enabled = NO;
	self.forwardButton = forwardButton;
	
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	self.toolbarItems = @[flexibleSpace, refreshButton, fixedSpace, backButton, fixedSpace, forwardButton];
	for (UIBarButtonItem *item in self.toolbarItems) {
		// item == fixedSpace ||
		if (item == flexibleSpace) {
			continue;
		}
		item.width = 44;
	}
	
	UIBarButtonItem *fullscreenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fullscreen"] style:UIBarButtonItemStylePlain target:self action:@selector(fullscreenAction:)];
	self.navigationItem.rightBarButtonItem = fullscreenButton;
	
	// loading indicator
	UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.loadingIndicator = loadingIndicator;
	self.navigationItem.leftItemsSupplementBackButton = YES;
	UIBarButtonItem *loadingButton = [[UIBarButtonItem alloc] initWithCustomView:loadingIndicator];
	self.navigationItem.leftBarButtonItem = loadingButton;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		[self updateConstraintsForTraitCollection:newCollection];
	} completion:nil];
}

- (void)updateConstraintsForTraitCollection:(UITraitCollection *)collection {
	//BOOL landscape = collection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
	self.fullscreen = NO;
}

#pragma mark - property

- (void)setFullscreen:(BOOL)fullscreen {
	_fullscreen = fullscreen;
	[self.navigationController setToolbarHidden:fullscreen animated:YES];
	[self.navigationController setNavigationBarHidden:fullscreen animated:YES];
}

- (void)setWebView:(UIView *)webView {
	_webView = webView;
	//webView.backgroundColor = [UIColor redColor];
	if (!webView) return;
	if ([webView isKindOfClass:[UIWebView class]]) {
		_uiWebView = (UIWebView *)webView;
		_uiWebView.delegate = self;
	} else if ([webView isKindOfClass:[WKWebView class]]) {
		_wkWebView = (WKWebView *)webView;
		_wkWebView.navigationDelegate = self;
	}
	__weak typeof(self) weakSelf = self;
	[self.KVOController observe:_webView keyPath:@"canGoBack" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		weakSelf.canGoBack = [[weakSelf.webView valueForKey:@"canGoBack"] boolValue];
	}];
	[self.KVOController observe:_webView keyPath:@"canGoForward" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		weakSelf.canGoBack = [[weakSelf.webView valueForKey:@"canGoForward"] boolValue];
	}];
	[self.KVOController observe:_webView keyPath:@"loading" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
		weakSelf.loading = [[weakSelf.webView valueForKey:@"loading"] boolValue];
	}];
}

- (void)setCanGoBack:(BOOL)canGoBack {
	_canGoBack = canGoBack;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.backButton.enabled = canGoBack;
	});
}
- (void)setCanGoForward:(BOOL)canGoForward {
	_canGoForward = canGoForward;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.forwardButton.enabled = canGoForward;
	});
}
- (void)setLoading:(BOOL)loading {
	_loading = loading;
	dispatch_async(dispatch_get_main_queue(), ^{
		//loading ? [self.loadingIndicator startAnimating] : [self.loadingIndicator stopAnimating];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = loading;
		self.refreshButton.image = [UIImage imageNamed:loading ? @"cancel" : @"refresh"];
	});
}
- (void)setLoadingProgress:(CGFloat)loadingProgress {
	_loadingProgress = loadingProgress;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.loadingProgressView.progress = loadingProgress;
	});
}

#pragma mark - action

- (void)fullscreenAction:(id)sender {
	self.fullscreen = YES;
}

- (void)refreshAction:(UIBarButtonItem *)sender {
	if (self.loading) {
		[self.wkWebView stopLoading];
		[self.uiWebView stopLoading];
		if (self.uiWebView) {
			self.loading = NO;
		}
	} else {
		[self.wkWebView reload];
		[self.uiWebView reload];
	}
}
- (void)backAction:(UIBarButtonItem *)sender {
	[self.wkWebView goBack];
	[self.uiWebView goBack];
}
- (void)forwardAction:(UIBarButtonItem *)sender {
	[self.wkWebView goForward];
	[self.uiWebView goForward];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)runAfterViewDidLoad:(ControllerHandlerBlock)handler {
	if (!handler) {
		return;
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.viewLoaded) {
			handler();
		} else {
			self.viewDidLoadHandler = handler;
		}
	});
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchBar.text]];
	[self.uiWebView loadRequest:request];
	[self.wkWebView loadRequest:request];
	[searchBar endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}


#pragma mark - UIWebViewDelegate

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	return YES;
//}
- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.loading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.loading = NO;
	self.canGoForward = webView.canGoForward;
	self.canGoBack = webView.canGoBack;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"error: %@", error);
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	NSLog(@"didFailNavigation: %@", error);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	NSLog(@"didFailProvisionalNavigation: %@", error);
}

@end
