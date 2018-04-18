//
//  SingleSelectionItem.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/18.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleSelectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) BOOL disable;

+ (instancetype)itemWithTitle:(NSString *)title;

@end
