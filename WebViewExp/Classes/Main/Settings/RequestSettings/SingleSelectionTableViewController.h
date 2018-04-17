//
//  SingleSelectionTableViewController.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectionTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<NSString *> *choices;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^selectedIndexChangeHandler)(__weak SingleSelectionTableViewController *controller);

@end
