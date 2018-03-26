//
//  SettingViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "SettingViewController.h"
#import "Settings.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_allGroups addObjectsFromArray:@[
									  [self generalSettings],
									  [self wkWebViewSettings]
									  ]];
}


- (ZFSettingGroup *)generalSettings {
	Settings *settings = [Settings sharedSettings];
	__weak typeof(settings) _settings = settings;
	
	// 9 - 允许链接预览
	ZFSettingItem *allowsLinkPreview = [ZFSettingItem itemWithIcon:nil title:@"允许链接预览" type:ZFSettingItemTypeSwitch];
	allowsLinkPreview.switchOn = settings.allowsLinkPreview;
	allowsLinkPreview.switchBlock = ^(BOOL on) {
		_settings.allowsLinkPreview = on;
	};
	
	// 禁止缩放页面
	ZFSettingItem *allowsScale = [ZFSettingItem itemWithIcon:nil title:@"禁止缩放页面" type:ZFSettingItemTypeSwitch];
	allowsScale.switchOn = settings.allowsScale;
	allowsScale.switchBlock = ^(BOOL on) {
		_settings.allowsScale = on;
	};
	
	// 抑制增量渲染
	ZFSettingItem *suppressesIncrementalRendering = [ZFSettingItem itemWithIcon:nil title:@"抑制增量渲染" type:ZFSettingItemTypeSwitch];
	suppressesIncrementalRendering.switchOn = settings.suppressesIncrementalRendering;
	suppressesIncrementalRendering.switchBlock = ^(BOOL on) {
		_settings.suppressesIncrementalRendering = on;
	};
	
	// 允许数据检测
	ZFSettingItem *allowsDataDetect = [ZFSettingItem itemWithIcon:nil title:@"允许数据检测" type:ZFSettingItemTypeSwitch];
	allowsDataDetect.switchOn = settings.allowsDataDetect;
	allowsDataDetect.switchBlock = ^(BOOL on) {
		_settings.allowsDataDetect = on;
	};
	
	// 允许内嵌播放
	ZFSettingItem *allowsInlineMediaPlayback = [ZFSettingItem itemWithIcon:nil title:@"允许内嵌播放" type:ZFSettingItemTypeSwitch];
	allowsInlineMediaPlayback.switchOn = settings.allowsInlineMediaPlayback;
	allowsInlineMediaPlayback.switchBlock = ^(BOOL on) {
		_settings.allowsInlineMediaPlayback = on;
	};
	
	// 禁止自动播放
	ZFSettingItem *banAutoPlay = [ZFSettingItem itemWithIcon:nil title:@"禁止自动播放" type:ZFSettingItemTypeSwitch];
	banAutoPlay.switchOn = settings.banAutoPlay;
	banAutoPlay.switchBlock = ^(BOOL on) {
		_settings.banAutoPlay = on;
	};
	
	// 允许 AirPlay
	ZFSettingItem *mediaPlaybackAllowsAirPlay = [ZFSettingItem itemWithIcon:nil title:@"允许 AirPlay" type:ZFSettingItemTypeSwitch];
	mediaPlaybackAllowsAirPlay.switchOn = settings.mediaPlaybackAllowsAirPlay;
	mediaPlaybackAllowsAirPlay.switchBlock = ^(BOOL on) {
		_settings.mediaPlaybackAllowsAirPlay = on;
	};
	
	// 允许画中画
	ZFSettingItem *allowsPictureInPictureMediaPlayback = [ZFSettingItem itemWithIcon:nil title:@"允许画中画" type:ZFSettingItemTypeSwitch];
	allowsPictureInPictureMediaPlayback.switchOn = settings.allowsPictureInPictureMediaPlayback;
	allowsPictureInPictureMediaPlayback.switchBlock = ^(BOOL on) {
		_settings.allowsPictureInPictureMediaPlayback = on;
	};
	
	ZFSettingGroup *group = [[ZFSettingGroup alloc] init];
	group.header = @"通用";
	group.items = @[allowsLinkPreview, allowsScale, suppressesIncrementalRendering, allowsDataDetect, allowsInlineMediaPlayback, banAutoPlay, mediaPlaybackAllowsAirPlay, allowsPictureInPictureMediaPlayback];
	
	return group;
}

- (ZFSettingGroup *)wkWebViewSettings {
	Settings *settings = [Settings sharedSettings];
	__weak typeof(settings) _settings = settings;
	
	// 允许手势导航
	ZFSettingItem *allowsBackForwardNavigationGestures = [ZFSettingItem itemWithIcon:nil title:@"允许手势导航" type:ZFSettingItemTypeSwitch];
	allowsBackForwardNavigationGestures.switchOn = settings.allowsBackForwardNavigationGestures;
	allowsBackForwardNavigationGestures.switchBlock = ^(BOOL on) {
		_settings.allowsBackForwardNavigationGestures = on;
	};
	
	ZFSettingGroup *group = [[ZFSettingGroup alloc] init];
	group.header = @"WKWebView";
	group.items = @[allowsBackForwardNavigationGestures];
	return group;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
