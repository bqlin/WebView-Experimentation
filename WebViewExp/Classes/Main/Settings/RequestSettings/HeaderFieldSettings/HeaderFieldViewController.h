//
//  HeaderFieldViewController.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderFieldViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *headerFields;

@property (nonatomic, copy) void (^headerFieldsChnageHandler)(__weak HeaderFieldViewController *controller);

@end
