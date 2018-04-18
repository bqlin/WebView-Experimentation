//
//  DualPadViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/9.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "DualPadViewController.h"
#import "SingleWebViewController.h"
#import <Masonry.h>
#import "WebViewBuilder.h"
#import "DualSplitView.h"
#import "BqUtil.h"

@interface DualPadViewController ()

@property (nonatomic, strong) UIView *uiWebView;
@property (nonatomic, strong) UIView *wkWebView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) DualSplitView *splitView;

@end

@implementation DualPadViewController

#pragma mark - property



#pragma mark - view controller

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupWebView];
	[self setupUI];
	[self layoutUI];
}

- (void)setupWebView {
	NSURLRequest *request = self.request;
	UIWebView *uiWebView = [WebViewBuilder uiWebView];
	[uiWebView loadRequest:request];
	WKWebView *wkWebView = [WebViewBuilder wkWebView];
	[wkWebView loadRequest:request];
	
	SingleWebViewController *uiViewController = [[SingleWebViewController alloc] initWithNibName:nil bundle:nil];
	uiViewController.webView = uiWebView;
	uiViewController.showNavigationBarLoadingIndicator = YES;
	self.uiWebView = [[UINavigationController alloc] initWithRootViewController:uiViewController].view;
	[self addChildViewController:uiViewController.navigationController];
	SingleWebViewController *wkViewController = [[SingleWebViewController alloc] initWithNibName:nil bundle:nil];
	wkViewController.webView = wkWebView;
	wkViewController.showNavigationBarLoadingIndicator = YES;
	self.wkWebView = [[UINavigationController alloc] initWithRootViewController:wkViewController].view;
	[self addChildViewController:wkViewController.navigationController];
}

- (void)setupUI {
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.title = @"UIWebView vs WKWebView";
	self.view.backgroundColor = [UIColor blackColor];
	
	self.containerView = [[UIView alloc] init];
	[self.view addSubview:self.containerView];
	self.containerView.backgroundColor = [UIColor yellowColor];
	self.splitView = [[DualSplitView alloc] initWithTapName:@"WKWebView" otherTapName:@"UIWebView"];
	
	[self.containerView addSubview:self.splitView];
	[self.containerView addSubview:self.uiWebView];
	[self.containerView addSubview:self.wkWebView];
	
	self.containerView.clipsToBounds = YES;
	self.splitView.clipsToBounds = YES;
}

- (void)layoutUI {
#if Xcode9
	if (BQ_AVAILABLE(11)) {
		[self.containerView makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
		}];
	} else {
		[self.containerView makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.mas_topLayoutGuide);
			make.bottom.equalTo(self.mas_bottomLayoutGuide);
			make.left.right.equalTo(self.view);
		}];
	}
#else
	[self.containerView makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_topLayoutGuide);
		make.bottom.equalTo(self.mas_bottomLayoutGuide);
		make.left.right.equalTo(self.view);
	}];
#endif
	
	CGFloat splitMargin = 30;
	_splitView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	[self.splitView setNeedsDisplay];
	[self.uiWebView makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(self.wkWebView).priorityMedium();
		make.left.top.bottom.equalTo(0);
		make.right.equalTo(self.wkWebView.left).offset(-splitMargin).priorityMedium();
	}];
	[self.wkWebView makeConstraints:^(MASConstraintMaker *make) {
		make.right.top.bottom.equalTo(0);
	}];
	[self.splitView makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(0);
		make.width.equalTo(self.containerView.height);
		make.height.equalTo(splitMargin);
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
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

@end
