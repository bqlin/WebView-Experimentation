//
//  DualPadViewController.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/9.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DualWebViewControllerProtocol.h"

@interface DualPadViewController : UIViewController <DualWebViewControllerProtocol>

@property (nonatomic, copy) NSURL *URL;

@end
