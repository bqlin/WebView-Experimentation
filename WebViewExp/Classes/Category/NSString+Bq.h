//
//  NSString+Bq.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/14.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Bq)

@property (nonatomic, copy, readonly) NSString *encodeUrl;
@property (nonatomic, copy, readonly) NSString *decodeUrl;

+ (instancetype)stringFromData:(NSData *)data;

@end
