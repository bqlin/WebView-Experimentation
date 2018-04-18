//
//  SingleSelectionItem.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/18.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "SingleSelectionItem.h"

@implementation SingleSelectionItem

+ (instancetype)itemWithTitle:(NSString *)title {
	SingleSelectionItem *item = [[self alloc] init];
	item.title = title;
	return item;
}

@end
