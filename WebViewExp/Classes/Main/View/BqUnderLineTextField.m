//
//  BqUnderLineTextField.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqUnderLineTextField.h"

IB_DESIGNABLE
@implementation BqUnderLineTextField

- (instancetype)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		[self commonInit];
	}
	return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.borderStyle = UITextBorderStyleNone;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	CGFloat height = rect.size.height;
	CGFloat width = rect.size.width;
	CGFloat underlineHeight = 1;
	UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, height - underlineHeight, width, underlineHeight)];
	[UIColor.grayColor setFill];
	[rectanglePath fill];
}

@end
