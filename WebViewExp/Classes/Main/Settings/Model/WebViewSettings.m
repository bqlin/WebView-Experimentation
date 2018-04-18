//
//  WebViewSettings.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/18.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "WebViewSettings.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BqUtil.h"

@implementation WebViewSettings

+ (instancetype)defaultSettings {
	WebViewSettings *settings = [[WebViewSettings alloc] init];
	[settings restoreToDefault];
	return settings;
}

- (void)restoreToDefault {
	UIWebView *webView = [[UIWebView alloc] init];
	_allowsScale = webView.scalesPageToFit;
	_suppressesIncrementalRendering = webView.suppressesIncrementalRendering;
	_allowsDataDetect = !(webView.dataDetectorTypes & UIDataDetectorTypeNone);
	_allowsInlineMediaPlayback = webView.allowsInlineMediaPlayback;
	_banAutoPlay = webView.mediaPlaybackRequiresUserAction;
	_mediaPlaybackAllowsAirPlay = webView.mediaPlaybackAllowsAirPlay;
	
	if (BQ_AVAILABLE(9)) {
		_allowsLinkPreview = webView.allowsLinkPreview;
		_allowsPictureInPictureMediaPlayback = webView.allowsPictureInPictureMediaPlayback;
	}
	webView = nil;
	
	WKWebView *wkWebView = [[WKWebView alloc] init];
	_allowsBackForwardNavigationGestures = wkWebView.allowsBackForwardNavigationGestures;
}

@end
