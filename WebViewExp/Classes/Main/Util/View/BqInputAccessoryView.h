//
//  BqInputAccessoryView.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/18.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BqInputAccessoryView : UIVisualEffectView

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSArray *inputKeys;

@end
