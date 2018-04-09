//
//  BqUtil.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/9.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqUtil.h"

@implementation BqUtil

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(UIViewController *)viewController {
	if (!title) {
		title = @"错误";
	}
	__weak typeof(viewController) weakViewController = viewController;
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	NSString *cancelTitle = @"确定";
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}];
	[alertController addAction:cancelAction];
	dispatch_async(dispatch_get_main_queue(), ^{
		[weakViewController presentViewController:alertController animated:YES completion:^{}];
	});
}

@end
