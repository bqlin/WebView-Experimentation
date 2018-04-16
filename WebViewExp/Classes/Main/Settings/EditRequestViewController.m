//
//  EditRequestViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "EditRequestViewController.h"

@interface EditRequestViewController ()

@property (weak, nonatomic) IBOutlet UITextView *uaTextView;
@property (weak, nonatomic) IBOutlet UITextField *timeoutTextField;

@end

@implementation EditRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupUI];
}

- (void)setupUI {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
	label.text = @"s";
	label.textColor = [UIColor darkGrayColor];
	self.timeoutTextField.rightView = label;
	self.timeoutTextField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - action

- (IBAction)resetAction:(UIBarButtonItem *)sender {
}

- (IBAction)doneAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
