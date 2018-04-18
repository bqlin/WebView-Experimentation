//
//  BqInputAccessoryView.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/18.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "BqInputAccessoryView.h"
#import <Masonry.h>

@implementation BqInputAccessoryView

- (void)setInputKeys:(NSArray *)inputKeys {
	_inputKeys = inputKeys;
	[self setupKeys:inputKeys];
}

- (void)setupKeys:(NSArray *)inputKeys {
	NSMutableArray *keyButtons = [NSMutableArray array];
	for (NSString *inputKey in inputKeys) {
		UIButton *keyButton = [self keyButtonWithTitle:inputKey];
		[self.contentView addSubview:keyButton];
		[self layoutKeyButton:keyButton previousButton:keyButtons.lastObject];
		[keyButtons addObject:keyButton];
	}
}

- (void)layoutKeyButton:(UIButton *)keyButton previousButton:(UIButton *)previousButton {
	CGFloat margin = 20;
	[keyButton makeConstraints:^(MASConstraintMaker *make) {
		if (previousButton) {
			make.left.equalTo(previousButton.right).offset(margin);
		} else {
			make.leftMargin.equalTo(margin);
		}
		make.centerY.equalTo(keyButton.superview);
		make.height.equalTo(30);
	}];
}

- (UIButton *)keyButtonWithTitle:(NSString *)title {
	title = [NSString stringWithFormat:@" %@ ", title];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:self action:@selector(keyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	UIColor *textColor = [UIColor colorWithRed:0.188 green:0.188 blue:0.188 alpha:1.000];
	[button setTitleColor:textColor forState:UIControlStateNormal];
	CALayer *layer = button.layer;
	layer.borderColor = textColor.CGColor;
	layer.borderWidth = 1;
	layer.cornerRadius = 6;
	return button;
}

- (void)keyButtonAction:(UIButton *)sender {
	NSString *keyTitle = [sender titleForState:UIControlStateNormal];
	keyTitle = [keyTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	self.textField.text = keyTitle;
}

@end
