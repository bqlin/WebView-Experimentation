//
//  KeyValueItem.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "KeyValueItem.h"

@implementation KeyValueItem

+ (instancetype)item {
	return [[self alloc] init];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"\"%@\" : \"%@\"", _key, _value];
}

- (BOOL)isEqualToItem:(KeyValueItem *)item {
	if (!item) {
		return NO;
	}
	NSString *selfKey = self.key;
	NSString *itemKey = item.key;
	
	return [selfKey isEqualToString:itemKey];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[KeyValueItem class]]) {
		return NO;
	}
	
	return [self isEqualToItem:object];
}

- (NSUInteger)hash {
	return [self.key hash] ^ [self.value hash];
}

@end
