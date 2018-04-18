//
//  Settings.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "Settings.h"
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
	//[user synchronize];
}

#pragma mark - SettingProtocol

+ (instancetype)defaultSettings {
	Settings *settings = [self sharedSettings];
	[settings restoreToDefault];
	return settings;
}

- (void)restoreToDefault {
	_webViewSettings = [WebViewSettings defaultSettings];
	_requestSettings = [RequestSettings defaultSettings];
}

@end
