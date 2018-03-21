//
//  WebViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/21.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

typedef void(^ControllerHandlerBlock)(void);

@interface WebViewController ()<UISearchBarDelegate>

@property (nonatomic, copy) ControllerHandlerBlock viewDidLoadHandler;

@property (nonatomic, strong, readonly) UIWebView *uiWebView;
@property (nonatomic, weak, readonly) WKWebView *wkWebView;
//@property (weak, nonatomic) IBOutlet UIView *webViewPlacehodler;

@end

@implementation WebViewController

- (void)dealloc {
	NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.viewDidLoadHandler) {
		self.viewDidLoadHandler();
		self.viewDidLoadHandler = nil;
	}
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.searchBarStyle = UISearchBarStyleMinimal;
	searchBar.text = @"https://www.baidu.com";
	searchBar.delegate = self;
	self.navigationItem.titleView = searchBar;
	
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//NSLog(@"%s", __FUNCTION__);
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//NSLog(@"%s", __FUNCTION__);
}

- (void)setupUI {
	UIView *webView = self.webView;
	[self.view addSubview:webView];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	id top = self.topLayoutGuide;
	NSDictionary *views = NSDictionaryOfVariableBindings(webView, top);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][webView]|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - property

- (void)setWebView:(UIView *)webView {
	_webView = webView;
	webView.backgroundColor = [UIColor redColor];
	if (!webView) return;
	if ([webView isKindOfClass:[UIWebView class]]) {
		_uiWebView = (UIWebView *)webView;
	} else if ([webView isKindOfClass:[WKWebView class]]) {
		_wkWebView = (WKWebView *)webView;
	}
	NSLog(@"webView: %@", webView);
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
	//NSLog(@"%s - %@", __FUNCTION__, [NSThread currentThread]);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchBar.text]];
	[self.uiWebView loadRequest:request];
	[self.wkWebView loadRequest:request];
}

@end
