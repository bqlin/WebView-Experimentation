//
//  WKWebViewExp.m
//  WebViewExp
//
//  Created by LinBq on 2017/9/12.
//  Copyright © 2017年 POLYV. All rights reserved.
//

#import "WKWebViewExp.h"
#import <WebKit/WebKit.h>

@interface WKWebViewExp ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WKWebViewExp

- (void)loadView {
	self.view = [[WKWebView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)go:(UIBarButtonItem *)sender {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textField.text]];
	WKWebView *webView = (WKWebView *)self.view;
	[webView loadRequest:request];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self go:nil];
	return YES;
}

@end
