//
//  Settings.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "Settings.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <YYModel.h>
static NSString * const SettingsKey = @"com.bq.webviewlab.settings";

@implementation Settings

static id _sharedInstance = nil;

+ (instancetype)sharedSettings {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [self settingsWithUserDefaults];
	});
	return _sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!_sharedInstance) {
			_sharedInstance = [super allocWithZone:zone];
		}
	});
	return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return _sharedInstance;
}

+ (instancetype)settingsWithUserDefaults {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSData *settingsData = [user dataForKey:SettingsKey];
	Settings *settings = nil;
	if (settingsData.length) {
		settings = [self yy_modelWithJSON:settingsData];
	} else {
		settings = [[self alloc] init];
		[settings restoreToDefault];
	}
	return settings;
}

- (void)writeSettings {
	NSData *settingsData = self.yy_modelToJSONData;
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	[user setObject:settingsData forKey:SettingsKey];
	[user synchronize];
}

- (void)restoreToDefault {
	UIWebView *webView = [[UIWebView alloc] init];
	_allowsScale = webView.scalesPageToFit;
	_suppressesIncrementalRendering = webView.suppressesIncrementalRendering;
	_allowsDataDetect = !(webView.dataDetectorTypes & UIDataDetectorTypeNone);
	_allowsInlineMediaPlayback = webView.allowsInlineMediaPlayback;
	_banAutoPlay = webView.mediaPlaybackRequiresUserAction;
	_mediaPlaybackAllowsAirPlay = webView.mediaPlaybackAllowsAirPlay;
	if (@available(iOS 9.0, *)) {
		_allowsLinkPreview = webView.allowsLinkPreview;
		_allowsPictureInPictureMediaPlayback = webView.allowsPictureInPictureMediaPlayback;
	}
	webView = nil;
	
	WKWebView *wkWebView = [[WKWebView alloc] init];
	_allowsBackForwardNavigationGestures = wkWebView.allowsBackForwardNavigationGestures;
}

@end
