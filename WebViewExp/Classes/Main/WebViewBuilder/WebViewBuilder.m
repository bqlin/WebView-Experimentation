//
//  WebViewBuilder.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/28.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "WebViewBuilder.h"
#import "Settings.h"

@implementation WebViewBuilder

+ (UIWebView *)uiWebView {
	Settings *settings = [Settings sharedSettings];
	UIWebView *webView = [[UIWebView alloc] init];
	
	webView.mediaPlaybackRequiresUserAction = settings.banAutoPlay;
	webView.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback;
	webView.allowsLinkPreview = settings.allowsLinkPreview;
	webView.scalesPageToFit = settings.allowsScale;
	webView.suppressesIncrementalRendering = settings.suppressesIncrementalRendering;
	webView.dataDetectorTypes = settings.allowsDataDetect ? UIDataDetectorTypeAll : UIDataDetectorTypeNone;
	webView.mediaPlaybackAllowsAirPlay = settings.mediaPlaybackAllowsAirPlay;
	webView.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
	
	return webView;
}
+ (WKWebView *)wkWebView {
	Settings *settings = [Settings sharedSettings];
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.ignoresViewportScaleLimits = settings.allowsScale;
	configuration.suppressesIncrementalRendering = settings.suppressesIncrementalRendering;
	configuration.dataDetectorTypes = settings.allowsDataDetect ? WKDataDetectorTypeAll : WKDataDetectorTypeNone;
	configuration.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback;
	configuration.mediaPlaybackRequiresUserAction = settings.banAutoPlay;
	configuration.mediaPlaybackAllowsAirPlay = settings.mediaPlaybackAllowsAirPlay;
	configuration.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
	
	WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
	webView.allowsLinkPreview = settings.allowsLinkPreview;
	webView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures;
	return webView;
}

+ (SFSafariViewController *)safariWithURL:(NSURL *)URL {
	SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:URL];
	return safari;
}

@end
