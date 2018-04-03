//
//  WebViewExpUITests.m
//  WebViewExpUITests
//
//  Created by Bq Lin on 2018/3/19.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebViewExpUITests-Swift.h"

@interface WebViewExpUITests : XCTestCase

@end

@implementation WebViewExpUITests

- (void)setUp {
    [super setUp];
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
//    self.continueAfterFailure = NO;
//    [[[XCUIApplication alloc] init] launch];
	
	XCUIApplication *app = [[XCUIApplication alloc] init];
	[Snapshot setupSnapshot:app];
	[app launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	// Xcode 8
	XCUIApplication *app = [[XCUIApplication alloc] init];
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
	
	// 设置
	[app.navigationBars[@"WebView Lab"].buttons[@"\u8bbe\u7f6e"] tap];
	[Snapshot snapshot:@"settings" waitForLoadingIndicator:YES];
	[app.navigationBars[@"\u8bbe\u7f6e"].buttons[@"\u8fd4\u56de"] tap];
	
	// WK，竖屏带键盘
	[app.segmentedControls.buttons[@"WKWebView"] tap];
	[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"WebView Lab"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextView].element tap];
	[Snapshot snapshot:@"00" waitForLoadingIndicator:YES];
	
	// 横屏带键盘
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeLeft;
	sleep(2);
	[Snapshot snapshot:@"01" waitForLoadingIndicator:YES];
	
	// 竖屏，切入
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
	XCUIElement *rocketLaunchButton = app.buttons[@"rocket launch"];
	[rocketLaunchButton tap];
	sleep(5);
	[Snapshot snapshot:@"02" waitForLoadingIndicator:YES];
	
	// 横屏
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeLeft;
	sleep(1);
	[Snapshot snapshot:@"03" waitForLoadingIndicator:YES];
	
	// 竖屏，返回，切 Safari
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
	[app.navigationBars[@"WKWebView"].buttons[@" "] tap];
	[app.segmentedControls.buttons[@"Safari"] tap];
	[rocketLaunchButton tap];
	sleep(5);
	[Snapshot snapshot:@"04" waitForLoadingIndicator:YES];
	
	// 横屏
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeLeft;
	sleep(1);
	[Snapshot snapshot:@"05" waitForLoadingIndicator:YES];
	
	// 竖屏，返回，且双屏
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
	[app.buttons[@"完成"] tap];
	[app.buttons[@"双屏"] tap];
	[rocketLaunchButton tap];
	sleep(5);
	[Snapshot snapshot:@"06" waitForLoadingIndicator:YES];
	
	// 横屏
	[XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeLeft;
	sleep(1);
	[Snapshot snapshot:@"07" waitForLoadingIndicator:YES];
	
	// Xcode 9
//	[Snapshot snapshot:@"lunch" timeWaitingForIdle:1];
}

@end
