//
//  RequestSettings.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "RequestSettings.h"
#import <UIKit/UIKit.h>

@interface RequestSettings ()

@property (nonatomic, copy) NSString *defaultUserAgent;

@end

@implementation RequestSettings

+ (instancetype)defaultSettings {
	RequestSettings *settings = [[self alloc] init];
	[settings restoreToDefault];
	return settings;
}

- (void)restoreToDefault {
	self.globalUserAgent = self.defaultUserAgent;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	_headerFields = request.allHTTPHeaderFields;
	if (request.HTTPBody.length)
		_httpBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
	else
		_httpBody = nil;
	_timeoutInterval = request.timeoutInterval;
	_httpMethod = request.HTTPMethod;
	_allowsCellularAccess = request.allowsCellularAccess;
	_cachePolicy = request.cachePolicy;
}

#pragma mark - property

- (void)setGlobalUserAgent:(NSString *)globalUserAgent {
	if (![_globalUserAgent isEqualToString:globalUserAgent]) {
		[self updateUserAgent:globalUserAgent];
	}
	_globalUserAgent = globalUserAgent;
}

- (NSString *)defaultUserAgent {
	if (!_defaultUserAgent) {
		_defaultUserAgent = [self requestUserAgent];
	}
	return _defaultUserAgent;
}

#pragma mark - private

- (NSString *)requestUserAgent {
	UIWebView *webView = [[UIWebView alloc] init];
	NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
	return userAgent;
}

- (void)updateUserAgent:(NSString *)userAgent {
	if (!userAgent) return;
	NSDictionary *dic =
  @{
	@"UserAgent": userAgent
	};
	[[NSUserDefaults standardUserDefaults] registerDefaults:dic];
}

@end
