//
//  RequestSettings.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingProtocol.h"

@interface RequestSettings : NSObject <SettingProtocol>

/// 全局 User-Agent
@property (nonatomic, copy) NSString *globalUserAgent;

/// 请求头信息
@property (nonatomic, strong) NSDictionary *headerFields;

/// 请求体
@property (nonatomic, copy) NSString *httpBody;

/// 请求方法
@property (nonatomic, copy) NSString *httpMethod;

/// 超时
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 允许蜂窝接入
@property (nonatomic, assign) BOOL allowsCellularAccess;

/// 缓存策略
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

@end
