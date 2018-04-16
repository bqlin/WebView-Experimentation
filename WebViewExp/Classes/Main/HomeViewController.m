//
//  HomeViewController.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "HomeViewController.h"
#import "SingleWebViewController.h"
#import "WebViewBuilder.h"
#import "DualWebViewController.h"
#import "DualPadViewController.h"
#import "ZFScanViewController.h"
#import "Settings.h"
#import "BqUtil.h"
#import "NSString+Bq.h"

static NSString * const GoWebViewSegueID = @"GoWebViewSegue";
static NSString * const DefaultURLKey = @"defaultURL_preference";

@interface HomeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (nonatomic, assign) WebViewType webViewType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomLayout;
@property (nonatomic, assign) CGFloat textViewBottomLayoutConstant;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (nonatomic, copy) NSString *lastUrl;
@property (nonatomic, strong) NSString *userUrl;

@end

@implementation HomeViewController

#pragma mark - property

- (NSString *)userUrl {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	return [user stringForKey:DefaultURLKey];
}
- (void)setUserUrl:(NSString *)userUrl {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	[user setObject:userUrl forKey:DefaultURLKey];
	//[user synchronize];
}

#pragma mark - view controller

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
	[self checkPasteboard];
}

- (void)setupUI {
	NSString *userUrl = self.userUrl;
	if (!userUrl.length) {
		userUrl = @"https://xw.qq.com";
	}
#if Xcode9
#else
	userUrl = @"https://github.com/bqlin";
#endif
	self.urlTextView.text = userUrl;
	self.lastUrl = userUrl;
	self.goButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
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
	[self.navigationController setToolbarHidden:YES animated:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
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

- (void)applicationWillEnterForeground:(NSNotification *)notification {
	[self checkPasteboard];
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

- (void)checkPasteboard {
	if (![Settings sharedSettings].enablePasteboardDetect) return;
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	if (!pasteboard.string.length) return;
	NSString *pasteString = nil;
	for (NSURL *URL in pasteboard.URLs) {
		if ([URL.absoluteString isEqualToString:self.urlTextView.text]) continue;
		pasteString = URL.absoluteString;
		break;
	}
	//NSLog(@"paste: %@", pasteString);
	if (!pasteString.length) {
		// 遇到 http 分拆 URL，取第一个与文本框不同的 URL
		NSString *tempString = pasteboard.string;
		tempString = [tempString stringByReplacingOccurrencesOfString:@"http" withString:@" http"];
		NSArray *subStrings = [tempString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		for (NSString *subString in subStrings) {
			//NSLog(@"sub: %@", subString);
			if (!subString.length || [subString isEqualToString:self.urlTextView.text]) continue;
			@try {
				if ([subString hasPrefix:@"http://"] || [subString hasPrefix:@"https://"]) {
					pasteString = subString;
					break;
				}
			} @catch (NSException *exception) {
			} @finally {
			}
		}
	}
	if (!pasteString.length) return;
	
	NSString *decodeString = pasteString.decodeUrl;
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用剪贴板链接？" message:decodeString preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	__weak typeof(self) weakSelf = self;
	[alertController addAction:[UIAlertAction actionWithTitle:@"使用" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		weakSelf.urlTextView.text = pasteString;
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[self presentViewController:alertController animated:YES completion:^{
		
	}];
}

- (void)addBarItems {
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
}

- (NSURL *)inputURL {
	NSString *url = self.urlTextView.text;
	url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (url.length > 0 && ![url isEqualToString:self.lastUrl]) { // url 与上次不一样则归档
		self.userUrl = url;
		self.lastUrl = url;
		self.urlTextView.text = url;
	}
	url = url.encodeUrl;
	if (!url.length) {
		[BqUtil alertWithTitle:nil message:@"URL 不能为空" delegate:self];
		return nil;
	}
	NSURL *URL = [NSURL URLWithString:url];
	return URL;
}

- (void)goWithType:(WebViewType)type sender:(id)sender {
	NSURL *URL = [self inputURL];
	if (!URL) return;
	switch (type) {
		case WebViewTypeUIWebView:
		case WebViewTypeWKWebView:{
			SingleWebViewController *vc = [[SingleWebViewController alloc] initWithNibName:nil bundle:nil];
			vc.webView = type == WebViewTypeUIWebView ? [WebViewBuilder uiWebView] : [WebViewBuilder wkWebView];
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
			[WebViewBuilder applySettingsToRequest:request];
			if ([vc.webView respondsToSelector:@selector(loadRequest:)]) {
				[vc.webView performSelector:@selector(loadRequest:) withObject:request];
			}
			[self.navigationController pushViewController:vc animated:YES];
		}break;
		case WebViewTypeSafari:{
			[self presentViewController:[WebViewBuilder safariWithURL:URL] animated:YES completion:^{
				
			}];
		}break;
		case WebViewTypeBoth:{
			UIViewController<DualWebViewControllerProtocol> *dualVc = nil;
			if(IS_IPAD){
				dualVc = [[DualPadViewController alloc] initWithNibName:nil bundle:nil];
			} else {
				dualVc = [[DualWebViewController alloc] initWithNibName:nil bundle:nil];
			}
			
			dualVc.URL = URL;
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

- (IBAction)goAction:(UIButton *)sender {
	CGPoint center = sender.center;
	[self goWithType:self.webViewType sender:sender];
	[UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		sender.center = CGPointMake(0, center.y);
		sender.alpha = 0;
	} completion:^(BOOL finished) {
		sender.center = center;
		sender.alpha = 1;
	}];
}

- (IBAction)test:(id)sender {
	
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
	//NSLog(@"unwindSegue: %@", unwindSegue);
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
			NSString *codeString = [barCodeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].decodeUrl;
			weakSelf.urlTextView.text = codeString;
		});
	};
	
	[self presentViewController:vc animated:YES completion:nil];
}
@end
