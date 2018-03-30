//
//  HomeViewController.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "HomeViewController.h"
#import "SingleWebViewController.h"
#import "Settings.h"
#import "WebViewBuilder.h"
#import "DualWebViewController.h"
#import "ZFScanViewController.h"

static NSString * const GoWebViewSegueID = @"GoWebViewSegue";

@interface HomeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (nonatomic, assign) WebViewType webViewType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomLayout;
@property (nonatomic, assign) CGFloat textViewBottomLayoutConstant;

@end

@implementation HomeViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
}

- (void)setupUI {
	[Settings sharedSettings];
	UIBarButtonItem *goButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rocket-launch"] style:UIBarButtonItemStylePlain target:self action:@selector(goAction:)];
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	self.toolbarItems = @[flexibleSpace, goButton, fixedSpace];
	for (UIBarButtonItem *item in self.toolbarItems) {
		if (item == fixedSpace || item == flexibleSpace) {
			continue;
		}
		item.width = 44;
	}
	self.textViewBottomLayoutConstant = self.textViewBottomLayout.constant;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - notification

- (void)keyboardWillShow:(NSNotification *)notification {
	if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) return;
	NSDictionary *userInfo = [notification userInfo];
	double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[UIView animateWithDuration:duration animations:^{
		self.textViewBottomLayout.constant = keyboardRect.size.height+8;
	} completion:^(BOOL finished) {
		
	}];
}

- (void)keyboardDidShow:(NSNotification *)notification {
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration animations:^{
		self.textViewBottomLayout.constant = self.textViewBottomLayoutConstant;
	}];
}

#pragma mark - private

- (NSURL *)inputURL {
	NSString *url = self.urlTextView.text;
	url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *URL = [NSURL URLWithString:url];
	return URL;
}

- (void)goWithType:(WebViewType)type sender:(id)sender {
	switch (type) {
		case WebViewTypeUIWebView:
		case WebViewTypeWKWebView:{
			SingleWebViewController *vc = [[SingleWebViewController alloc] initWithNibName:nil bundle:nil];
			vc.webView = type == WebViewTypeUIWebView ? [WebViewBuilder uiWebView] : [WebViewBuilder wkWebView];
			NSURLRequest *request = [NSURLRequest requestWithURL:[self inputURL]];
			if ([vc.webView respondsToSelector:@selector(loadRequest:)]) {
				[vc.webView performSelector:@selector(loadRequest:) withObject:request];
			}
			[self.navigationController pushViewController:vc animated:YES];
		}break;
		case WebViewTypeSafari:{
			[self presentViewController:[WebViewBuilder safariWithURL:[self inputURL]] animated:YES completion:^{
				
			}];
		}break;
		case WebViewTypeBoth:{
			DualWebViewController *dualVc = [[DualWebViewController alloc] initWithNibName:nil bundle:nil];
			dualVc.URL = [self inputURL];
			[self.navigationController pushViewController:dualVc animated:YES];
		}break;
	}
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	NSString *text = textView.text;
	NSRange range = [text rangeOfString:@"\n"];
	if (range.length > 0) {
		text = [text stringByReplacingCharactersInRange:range withString:@""];
		textView.text = text;
		[textView endEditing:YES];
		[self goWithType:self.webViewType sender:textView];
	}
}

#pragma mark - Action

- (void)goAction:(id)sender {
	[self goWithType:self.webViewType sender:sender];
}

- (IBAction)test:(id)sender {
	
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
	NSLog(@"unwindSegue: %@", unwindSegue);
}
- (IBAction)cleanAction:(UIBarButtonItem *)sender {
	self.urlTextView.text = nil;
}

- (IBAction)webViewTypeChangeAction:(UISegmentedControl *)sender {
	self.webViewType = sender.selectedSegmentIndex;
}

- (IBAction)scanQRCodeAction:(UIBarButtonItem *)sender {
	ZFScanViewController * vc = [[ZFScanViewController alloc] init];
	__weak typeof(self) weakSelf = self;
	vc.returnScanBarCodeValue = ^(NSString * barCodeString){
		dispatch_async(dispatch_get_main_queue(), ^{
			NSString *codeString = [barCodeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			// 解码
			codeString = [codeString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			// 编码
			//codeString = [codeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			weakSelf.urlTextView.text = codeString;
		});
	};
	
	[self presentViewController:vc animated:YES completion:nil];
}
@end
