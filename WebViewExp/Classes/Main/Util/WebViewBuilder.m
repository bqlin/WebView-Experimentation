//
//  WebViewBuilder.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/28.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "WebViewBuilder.h"
#import "Settings.h"
#import "BqUtil.h"

@implementation WebViewBuilder

+ (UIWebView *)uiWebView {
	Settings *settings = [Settings sharedSettings];
	UIWebView *webView = [[UIWebView alloc] init];
	
	webView.mediaPlaybackRequiresUserAction = settings.banAutoPlay;
	webView.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback;
	webView.scalesPageToFit = settings.allowsScale;
	webView.suppressesIncrementalRendering = settings.suppressesIncrementalRendering;
	webView.dataDetectorTypes = settings.allowsDataDetect ? UIDataDetectorTypeAll : UIDataDetectorTypeNone;
	webView.mediaPlaybackAllowsAirPlay = settings.mediaPlaybackAllowsAirPlay;
	
	if (BQ_AVAILABLE(9)) {
		webView.allowsLinkPreview = settings.allowsLinkPreview;
		webView.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
	}
	
	return webView;
}
+ (WKWebView *)wkWebView {
	Settings *settings = [Settings sharedSettings];
	WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
	configuration.suppressesIncrementalRendering = settings.suppressesIncrementalRendering;
	configuration.allowsInlineMediaPlayback = settings.allowsInlineMediaPlayback;
	configuration.mediaPlaybackRequiresUserAction = settings.banAutoPlay;
	configuration.mediaPlaybackAllowsAirPlay = settings.mediaPlaybackAllowsAirPlay;
	if (BQ_AVAILABLE(9)) {
		configuration.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
	}
	
	WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
	if (BQ_AVAILABLE(9)) {
		webView.allowsLinkPreview = settings.allowsLinkPreview;
		webView.allowsBackForwardNavigationGestures = settings.allowsBackForwardNavigationGestures;
	}
	if (BQ_AVAILABLE(10)) {
		configuration.dataDetectorTypes = settings.allowsDataDetect ? WKDataDetectorTypeAll : WKDataDetectorTypeNone;
		configuration.ignoresViewportScaleLimits = settings.allowsScale;
	}
	return webView;
}

+ (SFSafariViewController *)safariWithURL:(NSURL *)URL {
	SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:URL];
	return safari;
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
		if (BQ_AVAILABLE(9)) {
			_webView.allowsLinkPreview = settings.allowsLinkPreview;
			_webView.allowsPictureInPictureMediaPlayback = settings.allowsPictureInPictureMediaPlayback;
		}
		return _webView;
	} else if ([webView isKindOfClass:[WKWebView class]]) {
		return [WebViewBuilder wkWebView];
	}
	return nil;
}

@end
