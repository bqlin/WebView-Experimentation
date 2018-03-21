//
//  HomeViewController.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import <WebKit/WebKit.h>

static NSString * const GoWebViewSegueID = @"GoWebViewSegue";

@interface HomeViewController ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (nonatomic, strong) UIView *webView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.webView = [[UIWebView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)webViewTypeChangeAction:(UISwitch *)sender {
	self.webView = sender.on ? [self uiWebView] : [self wkWebView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WebViewController *vc = (WebViewController *)segue.destinationViewController;
	
	if ([vc isKindOfClass:[WebViewController class]]) {
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextView.text]];
		if ([self.webView respondsToSelector:@selector(loadRequest:)]) {
			[self.webView performSelector:@selector(loadRequest:) withObject:request];
		}
		vc.webView = self.webView;
	}
	NSLog(@"%s - %@", __FUNCTION__, [NSThread currentThread]);
}

#pragma mark - private

- (UIWebView *)uiWebView {
	UIWebView *webView = [[UIWebView alloc] init];
	webView.mediaPlaybackRequiresUserAction = NO;
	webView.allowsInlineMediaPlayback = YES;
	return webView;
}
- (WKWebView *)wkWebView {
	WKWebView *webView = [[WKWebView alloc] init];
	return webView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	NSString *text = textView.text;
	NSRange range = [text rangeOfString:@"\n"];
	if (range.length > 0) {
		text = [text stringByReplacingCharactersInRange:range withString:@""];
		textView.text = text;
		[textView endEditing:YES];
		[self performSegueWithIdentifier:GoWebViewSegueID sender:textView];
	}
}

@end
