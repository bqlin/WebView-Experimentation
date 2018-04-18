//
//  KeyValueFieldCell.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyValueItem.h"

@class KeyValueFieldCell;

@protocol KeyValueFieldCellDelegate <NSObject>

@optional
- (void)cell:(KeyValueFieldCell *)cell didBeginEditing:(UITextField *)textField;

@end

@interface KeyValueFieldCell : UITableViewCell

@property (nonatomic, strong) KeyValueItem *item;

@property (nonatomic, weak) id<KeyValueFieldCellDelegate> delegate;

@end
