//
//  DualWebViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/28.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "DualWebViewController.h"
#import "WebViewBuilder.h"
#import <Masonry.h>
#import "DualSplitView.h"
#import "BqConstant.h"

@interface DualWebViewController ()

@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) DualSplitView *splitView;

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation DualWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setupUI];
}

- (void)setupUI {
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.title = @"UIWebView vs WKWebView";
	self.view.backgroundColor = [UIColor blackColor];
	
	self.containerView = [[UIView alloc] init];
	[self.view addSubview:self.containerView];
	UIView *superview = self.view;
	
	if (BQ_AVAILABLE(11)) {
		[self.containerView makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
		}];
	} else {
		[self.containerView makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.mas_topLayoutGuide);
			make.bottom.equalTo(self.mas_bottomLayoutGuide);
			make.left.right.equalTo(superview);
		}];
	}
	
	[self.containerView addSubview:self.splitView];
	[self.containerView addSubview:self.uiWebView];
	[self.containerView addSubview:self.wkWebView];
	
	self.containerView.clipsToBounds = YES;
	self.splitView.clipsToBounds = YES;
	[self updateConstraintsForTraitCollection:self.traitCollection];
	
	[self addToolBarButtons];
}

- (void)addToolBarButtons {
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)refreshAction:(UIBarButtonItem *)sender {
	[self.wkWebView reload];
	[self.uiWebView reload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		[self updateConstraintsForTraitCollection:newCollection];
	} completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - property

- (UIWebView *)uiWebView {
	if (!_uiWebView) {
		_uiWebView = [WebViewBuilder uiWebView];
//		_uiWebView = [[UIView alloc] init];
//		_uiWebView.backgroundColor = [UIColor redColor];
	}
	return _uiWebView;
}
- (WKWebView *)wkWebView {
	if (!_wkWebView) {
		_wkWebView = [WebViewBuilder wkWebView];
//		_wkWebView = [[UIView alloc] init];
//		_wkWebView.backgroundColor = [UIColor orangeColor];
	}
	return _wkWebView;
}
- (DualSplitView *)splitView {
	if (!_splitView) {
		_splitView = [[DualSplitView alloc] initWithTapName:@"WKWebView" otherTapName:@"UIWebView"];
		_splitView.backgroundColor = [UIColor cyanColor];
	}
	return _splitView;
}

- (void)setURL:(NSURL *)URL {
	_URL = URL;
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[self.uiWebView loadRequest:request];
	[self.wkWebView loadRequest:request];
}

#pragma mark - private

- (void)updateConstraintsForTraitCollection:(UITraitCollection *)collection {
	BOOL landscape = collection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
	[self.navigationController setNavigationBarHidden:landscape animated:YES];
	
	// VLF 布局
//	UIView *wkView = self.wkWebView;
//	UIView *uiView = self.uiWebView;
//	UIView *splitView = self.splitView;
//	splitView.translatesAutoresizingMaskIntoConstraints = wkView.translatesAutoresizingMaskIntoConstraints = uiView.translatesAutoresizingMaskIntoConstraints = NO;
//	NSDictionary *views = NSDictionaryOfVariableBindings(wkView, uiView, splitView);
//
//	NSMutableArray<NSLayoutConstraint *> *newConstrains = [NSMutableArray array];
//	if (landscape) {
////		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wkView][uiView(==wkView)]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
////		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[uiView(==wkView)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//		splitView.transform = CGAffineTransformMakeRotation(M_PI_2);
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wkView]-(44)-[uiView(wkView)]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[uiView(wkView)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splitView(320)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splitView(44)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//
//	} else {
//		splitView.transform = CGAffineTransformIdentity;
////		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[uiView(==wkView)]|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
////		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wkView][uiView(==wkView)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wkView][splitView(44)][uiView(wkView)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[uiView(wkView)]|" options:0 metrics:nil views:views]];
//		[newConstrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[splitView(wkView)]" options:0 metrics:nil views:views]];
//	}
//	[NSLayoutConstraint deactivateConstraints:self.constraints];
//	self.constraints = newConstrains;
//	[NSLayoutConstraint activateConstraints:newConstrains];
	
	UIView *superview = self.containerView;
	CGFloat splitMargin = 30;
	// !!!: 相等需使用较低优先级
	if (landscape) {
		_splitView.transform = CGAffineTransformMakeRotation(-M_PI_2);
		[self.splitView setNeedsDisplay];
		[self.uiWebView remakeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(self.wkWebView).priorityMedium();
			make.left.top.bottom.equalTo(0);
			make.right.equalTo(self.wkWebView.left).offset(-splitMargin).priorityMedium();
			
		}];
		[self.wkWebView remakeConstraints:^(MASConstraintMaker *make) {
			make.right.top.bottom.equalTo(0);
		}];
//		[self.splitView remakeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(self.uiWebView.right).priorityMedium();
//			make.right.equalTo(self.wkWebView.left).priorityMedium();
//			make.top.bottom.equalTo(0);
//		}];
		[self.splitView remakeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(0);
			make.width.equalTo(superview.height);
			make.height.equalTo(splitMargin);
		}];

	} else {
		_splitView.transform = CGAffineTransformIdentity;
		[self.splitView setNeedsDisplay];
		[self.uiWebView remakeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(self.wkWebView).priorityMedium();
			make.top.left.right.equalTo(0);
			make.bottom.equalTo(self.wkWebView.top).offset(-splitMargin).priorityMedium();
		}];
		[self.wkWebView remakeConstraints:^(MASConstraintMaker *make) {
			make.bottom.left.right.equalTo(0);
		}];
//		[self.splitView remakeConstraints:^(MASConstraintMaker *make) {
//			make.right.left.equalTo(0);
//			make.top.equalTo(self.uiWebView.bottom).priorityMedium();
//			make.bottom.equalTo(self.wkWebView.top).priorityMedium();
//		}];
		[self.splitView remakeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(0);
			make.width.equalTo(superview);
			make.height.equalTo(splitMargin);
		}];
	}
}

@end
