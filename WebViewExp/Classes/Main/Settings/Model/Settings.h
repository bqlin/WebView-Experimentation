//
//  Settings.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestSettings.h"
#import "WebViewSettings.h"

@interface Settings : NSObject <SettingProtocol>

#pragma mark - 其他

/// 启用剪贴板识别
@property (nonatomic, assign) BOOL enablePasteboardDetect;

@property (nonatomic, strong) WebViewSettings *webViewSettings;

@property (nonatomic, strong) RequestSettings *requestSettings;

+ (instancetype)sharedSettings;

/// 保存值
- (void)writeSettings;

@end
