//
//  ViewController.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) UIView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.webView = [[UIWebView alloc] init];
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
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
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

@end
