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

@property (nonatomic, strong) NSArray<UILabel *> *labels;
@property (nonatomic, strong) NSArray<UIColor *> *colors;

@end

@implementation DualSplitView

#pragma mark - property

- (NSArray<UILabel *> *)labels {
	if (!_labels) {
		NSMutableArray *labels = [NSMutableArray array];
		for (int i = 0; i < 2; i++) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = self.colors[i];
			[labels addObject:label];
		}
		_labels = labels;
	}
	return _labels;
}

- (NSArray<UIColor *> *)colors {
	if (!_colors) {
		_colors = @[
					[UIColor colorWithHue:0.478 saturation:0.349 brightness:1.000 alpha:1.000], [UIColor colorWithHue:0.771 saturation:0.400 brightness:1.000 alpha:1.000],
//					[UIColor colorWithWhite:0.8 alpha:1], [UIColor colorWithHue:0.028 saturation:0.095 brightness:0.247 alpha:1.000],
//					[UIColor colorWithHue:0.652 saturation:0.086 brightness:1.000 alpha:1.000], [UIColor colorWithHue:0.126 saturation:0.271 brightness:0.839 alpha:1.000],
					];
	}
	return _colors;
}

- (instancetype)initWithTapName:(NSString *)tapName otherTapName:(NSString *)otherTapName {
	if (self = [super initWithFrame:CGRectZero]) {
		self.labels[0].text = tapName;
		self.labels[1].text = otherTapName;
		[self setupUI];
	}
	return self;
}

- (void)setupUI {
	[self addSubview:self.labels[0]];
	[self addSubview:self.labels[1]];
	[self.labels[0] makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.equalTo(0);
		make.bottom.equalTo(4);
		make.right.equalTo(self.labels[1].left).offset(-30);
		make.width.equalTo(self.labels[1]);
	}];
	[self.labels[1] makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.right.equalTo(0);
		make.top.equalTo(-4);
	}];
}

- (void)drawRect:(CGRect)rect {
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	//// Color Declarations
	
	UIColor* tab0Color = self.colors[1];
	UIColor* tab1Color = self.colors[0];
	
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
