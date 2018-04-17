//
//  KeyValueItem.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueItem : NSObject

@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;

+ (instancetype)item;

@end
