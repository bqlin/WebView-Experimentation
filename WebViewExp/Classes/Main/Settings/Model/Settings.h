//
//  Settings.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

#pragma mark - 其他

/// 启用剪贴板识别
@property (nonatomic, assign) BOOL enablePasteboardDetect;

#pragma mark - 通用

// API_AVAILABLE(ios(11.0),tvos(11.0))

/// 允许链接预览 - 9
@property (nonatomic, assign) BOOL allowsLinkPreview API_AVAILABLE(ios(9.0));

/// 禁止缩放页面
@property (nonatomic, assign) BOOL allowsScale;

/// 抑制增量渲染
@property (nonatomic, assign) BOOL suppressesIncrementalRendering;

/// 允许数据检测
@property (nonatomic, assign) BOOL allowsDataDetect;

/// 允许内嵌播放
@property (nonatomic, assign) BOOL allowsInlineMediaPlayback;

/// 禁止自动播放
@property (nonatomic, assign) BOOL banAutoPlay;

/// 允许 AirPlay
@property (nonatomic, assign) BOOL mediaPlaybackAllowsAirPlay;

/// 允许画中画
@property (nonatomic, assign) BOOL allowsPictureInPictureMediaPlayback API_AVAILABLE(ios(9.0));

#pragma mark - WKWebView

/// 允许手势导航
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures;

+ (instancetype)sharedSettings;

/// 恢复默认设置
- (void)restoreToDefault;

/// 保存值
- (void)writeSettings;

@end
