//
//  NSString+Bq.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/14.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "NSString+Bq.h"

@implementation NSString (Bq)

- (NSString *)encodeUrl {
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)decodeUrl {
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (instancetype)stringFromData:(NSData *)data {
	if (!data.length) {
		return @"";
	} else {
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
}

@end
