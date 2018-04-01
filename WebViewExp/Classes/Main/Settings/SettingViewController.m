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

- (void)dealloc {
	[[Settings sharedSettings] writeSettings];
	//NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"设置";
	[self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)loadData {
	_allGroups = @[
				   [self generalSettings],
				   [self uiWebViewSettings],
				   [self wkWebViewSettings]
				   ].mutableCopy;
}

- (ZFSettingGroup *)uiWebViewSettings {
	Settings *settings = [Settings sharedSettings];
	__weak typeof(settings) _settings = settings;
	
	// 禁止缩放页面
	ZFSettingItem *allowsScale = [ZFSettingItem itemWithIcon:nil title:@"允许缩放页面" type:ZFSettingItemTypeSwitch];
	allowsScale.switchOn = settings.allowsScale;
	allowsScale.switchBlock = ^(BOOL on) {
		_settings.allowsScale = on;
	};
	
	ZFSettingGroup *group = [[ZFSettingGroup alloc] init];
	group.header = @"UIWebView";
	group.items = @[allowsScale];
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

- (ZFSettingGroup *)generalSettings {
	Settings *settings = [Settings sharedSettings];
	__weak typeof(settings) _settings = settings;
	
	// 9 - 允许链接预览
	ZFSettingItem *allowsLinkPreview = [ZFSettingItem itemWithIcon:nil title:@"允许链接预览" type:ZFSettingItemTypeSwitch];
	allowsLinkPreview.switchOn = settings.allowsLinkPreview;
	allowsLinkPreview.switchBlock = ^(BOOL on) {
		_settings.allowsLinkPreview = on;
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
	ZFSettingItem *banAutoPlay = [ZFSettingItem itemWithIcon:nil title:@"允许自动播放" type:ZFSettingItemTypeSwitch];
	banAutoPlay.switchOn = !settings.banAutoPlay;
	banAutoPlay.switchBlock = ^(BOOL on) {
		_settings.banAutoPlay = !on;
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
	
	NSMutableArray *items = [NSMutableArray array];
	[items addObjectsFromArray:@[suppressesIncrementalRendering, allowsDataDetect, allowsInlineMediaPlayback, banAutoPlay, mediaPlaybackAllowsAirPlay]];
	if (@available(iOS 9.0, *)) {
		[items addObjectsFromArray:@[allowsLinkPreview, allowsPictureInPictureMediaPlayback]];
	}
	
	ZFSettingGroup *group = [[ZFSettingGroup alloc] init];
	group.header = @"通用";
	group.footer = @"上述设置将应用于 UIWebView 和 WKWebView";
	group.items = items;
	
	return group;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)restoreAction:(id)sender {
	[[Settings sharedSettings] restoreToDefault];
	if ([self.view isKindOfClass:[UITableView class]]) {
		UITableView *tableView = (UITableView *)self.view;
		[self loadData];
		[tableView reloadData];
	}
}

@end
