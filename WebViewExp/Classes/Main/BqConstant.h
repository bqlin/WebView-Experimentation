//
//  BqConstant.h
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#ifndef BqConstant_h
#define BqConstant_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
// available for iOS 11
#define BQ_AVAILABLE(v) @available(iOS v, *)
#else
// can not use iOS 11 API
#define BQ_AVAILABLE(v) ([UIDevice currentDevice].systemVersion.floatValue > (v))
#endif

#endif /* BqConstant_h */
