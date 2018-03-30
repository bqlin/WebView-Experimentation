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

static NSString * const GoWebViewSegueID = @"GoWebViewSegue";

@interface HomeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
//@property (nonatomic, strong) id webView;
@property (nonatomic, assign) WebViewType webViewType;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	NSLog(@"%s", __FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (NSURL *)inputURL {
	NSString *url = self.urlTextView.text;
	url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSURL *URL = [NSURL URLWithString:url];
	return URL;
}

- (id)updateSettingsWithWebView:(id)webView {
	Settings *settings = [Settings sharedSettings];
	if ([webView isKindOfClass:[UIWebView class]]) {
		UIWebView *_webView = webView;
		_webView.mediaPlaybackRequiresUserAction = settings.banAutoPlay;
		_webView.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback;
		_webView.scalesPageToFit = settings.allowsScale;
		_webView.suppressesIncrementalRendering = settings.suppressesIncrementalRendering;
		_webView.dataDetectorTypes = settings.allowsDataDetect ? UIDataDetectorTypeAll : UIDataDetectorTypeNone;
		_webView.mediaPlaybackAllowsAirPlay = settings.mediaPlaybackAllowsAirPlay;
		if (@available(iOS 9.0, *)) {
			_webView.allowsLinkPreview = settings.allowsLinkPreview;
			_webView.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
		}
		return _webView;
	} else if ([webView isKindOfClass:[WKWebView class]]) {
		return [WebViewBuilder wkWebView];
	}
	return nil;
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
- (IBAction)test:(id)sender {
	NSURL *URL = [NSURL URLWithString:self.urlTextView.text];
	SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:URL];
//	[self.navigationController pushViewController:safari animated:YES];
	[self presentViewController:safari animated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
	NSLog(@"unwindSegue: %@", unwindSegue);
}

- (IBAction)webViewTypeSwitchAction:(UISwitch *)sender {
	//self.webView = sender.on ? [self uiWebView] : [self wkWebView];
}
- (IBAction)webViewTypeChangeAction:(UISegmentedControl *)sender {
	self.webViewType = sender.selectedSegmentIndex;
}
@end
