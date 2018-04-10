//
//  BqUtil.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/9.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define XCode9 __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0

#if XCode9
// available for iOS 11
#define BQ_AVAILABLE(v) @available(iOS v, *)

#else
// can not use iOS 11 API
#define BQ_AVAILABLE(v) ([UIDevice currentDevice].systemVersion.floatValue > (v))

#endif

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#import <UIKit/UIKit.h>

@interface BqUtil : NSObject

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(UIViewController *)viewController;

@end
