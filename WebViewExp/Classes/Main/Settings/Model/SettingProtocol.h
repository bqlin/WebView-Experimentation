//
//  SettingProtocol.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingProtocol <NSObject>

/// 默认设置
+ (instancetype)defaultSettings;

/// 恢复默认设置
- (void)restoreToDefault;

@end
