//
//  DualWebViewController.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/28.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DualWebViewControllerProtocol.h"

@interface DualWebViewController : UIViewController <DualWebViewControllerProtocol>

@property (nonatomic, copy) NSURL *URL;

@end
