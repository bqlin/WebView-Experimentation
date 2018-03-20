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
	[Snapshot snapshot:@"01Home" waitForLoadingIndicator:YES];
	[[[XCUIApplication alloc] init].toolbars.buttons[@"UIWebView"] tap];
	[Snapshot snapshot:@"02WebView" waitForLoadingIndicator:YES];
	
	// Xcode 9
//	[Snapshot snapshot:@"lunch" timeWaitingForIdle:1];
}

@end
