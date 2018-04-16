//
//  RequestSettings.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "RequestSettings.h"
#import <UIKit/UIKit.h>

@implementation RequestSettings

+ (instancetype)defaultSettings {
	return [[self alloc] init];
}

- (instancetype)init {
	if (self = [super init]) {
		[self restoreToDefault];
	}
	return self;
}

#pragma mark - property

- (void)setGlobalUserAgent:(NSString *)globalUserAgent {
	if (![_globalUserAgent isEqualToString:globalUserAgent]) {
		[self updateUserAgent:globalUserAgent];
	}
	_globalUserAgent = globalUserAgent;
}

- (void)restoreToDefault {
	self.globalUserAgent = [self requestUserAgent];
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

- (NSString *)requestUserAgent {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
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
