//
//  KeyValueFieldCell.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "KeyValueFieldCell.h"

@interface KeyValueFieldCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end

@implementation KeyValueFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.keyTextField.delegate = self.valueTextField.delegate = self;
	self.keyTextField.returnKeyType = self.valueTextField.returnKeyType = UIReturnKeyNext;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - property

- (void)setItem:(KeyValueItem *)item {
	_item = item;
	self.keyTextField.text = item.key;
	self.valueTextField.text = item.value;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if ([self.delegate respondsToSelector:@selector(cell:didBeginEditing:)]) {
		[self.delegate cell:self didBeginEditing:textField];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == _keyTextField) {
		self.item.key = textField.text;
	} else if (textField == _valueTextField) {
		self.item.value = textField.text;
	}
	//NSLog(@"%s - %@", __FUNCTION__, textField);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.keyTextField) {
		[self.valueTextField becomeFirstResponder];
	} else {
		[self.keyTextField becomeFirstResponder];
	}
	return NO;
}

@end
