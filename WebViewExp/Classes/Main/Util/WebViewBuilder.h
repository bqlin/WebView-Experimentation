//
//  WebViewBuilder.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/28.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>

typedef NS_ENUM(NSInteger, WebViewType) {
	WebViewTypeUIWebView = 0,
	WebViewTypeWKWebView,
	WebViewTypeSafari,
	WebViewTypeBoth
};

@interface WebViewBuilder : NSObject

+ (UIWebView *)uiWebView;
+ (WKWebView *)wkWebView;
+ (SFSafariViewController *)safariWithURL:(NSURL *)URL;

/// 应用设置到请求
+ (void)applySettingsToRequest:(NSMutableURLRequest *)request;

@end
