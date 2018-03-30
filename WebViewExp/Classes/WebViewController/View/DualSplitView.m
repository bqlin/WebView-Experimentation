//
//  DualSplitView.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/3/29.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "DualSplitView.h"
#import <Masonry.h>

@interface DualSplitView ()

@property (nonatomic, copy) NSString *tap0Name;
@property (nonatomic, copy) NSString *tap1Name;

@property (nonatomic, strong) UILabel *tap0Label;
@property (nonatomic, strong) UILabel *tap1Label;

@end

@implementation DualSplitView

#pragma mark - property

- (UILabel *)tap0Label {
	if (!_tap0Label) {
		_tap0Label = [[UILabel alloc] initWithFrame:CGRectZero];
		_tap0Label.textAlignment = NSTextAlignmentCenter;
	}
	return _tap0Label;
}

- (UILabel *)tap1Label {
	if (!_tap1Label) {
		_tap1Label = [[UILabel alloc] initWithFrame:CGRectZero];
		_tap1Label.textAlignment = NSTextAlignmentCenter;
	}
	return _tap1Label;
}

- (instancetype)initWithTapName:(NSString *)tapName otherTapName:(NSString *)otherTapName {
	if (self = [super initWithFrame:CGRectZero]) {
//		_tap0Name = tapName;
//		_tap1Name = otherTapName;
		self.tap0Label.text = tapName;
		self.tap1Label.text = otherTapName;
		[self setupUI];
	}
	return self;
}

- (void)setupUI {
	[self addSubview:self.tap0Label];
	[self addSubview:self.tap1Label];
	[self.tap0Label makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.left.equalTo(0);
		make.right.equalTo(self.tap1Label.left).offset(-30);
		make.width.equalTo(self.tap1Label);
	}];
	[self.tap1Label makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.equalTo(0);
	}];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	NSLog(@"rect: %@", NSStringFromCGRect(rect));
	
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	//// Color Declarations
	UIColor* tab0Color = [UIColor colorWithHue:0.771 saturation:0.400 brightness:1.000 alpha:1.000];
	UIColor* tab1Color = [UIColor colorWithHue:0.478 saturation:0.349 brightness:1.000 alpha:1.000];
	
	CGFloat longWidth = (width + height)/2;
	CGFloat shortWidth = (width - height)/2;
	CGFloat borderHeight = 4;
	
	//// tap1 Drawing
	UIBezierPath* tap1Path = [UIBezierPath bezierPath];
	[tap1Path moveToPoint: CGPointMake(0, height)];
	[tap1Path addLineToPoint: CGPointMake(longWidth, height)];
	[tap1Path addLineToPoint: CGPointMake(shortWidth, -0)];
	[tap1Path addLineToPoint: CGPointMake(0, -0)];
	[tap1Path addLineToPoint: CGPointMake(0, height)];
	[tap1Path closePath];
	[tab0Color setFill];
	[tap1Path fill];
	
	
	//// tap0 Drawing
	UIBezierPath* tap0Path = [UIBezierPath bezierPath];
	[tap0Path moveToPoint: CGPointMake(longWidth, height)];
	[tap0Path addLineToPoint: CGPointMake(width, height)];
	[tap0Path addLineToPoint: CGPointMake(width, 0)];
	[tap0Path addLineToPoint: CGPointMake(shortWidth, -0)];
	[tap0Path addLineToPoint: CGPointMake(longWidth, height)];
	[tap0Path closePath];
	[tab1Color setFill];
	[tap0Path fill];
	
	//// bottomBorder Drawing
	UIBezierPath* bottomBorderPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, height-borderHeight, width, borderHeight)];
	[tab0Color setFill];
	[bottomBorderPath fill];
	
	//// topBorder Drawing
	UIBezierPath* topBorderPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, width, borderHeight)];
	[tab1Color setFill];
	[topBorderPath fill];
}





@end
