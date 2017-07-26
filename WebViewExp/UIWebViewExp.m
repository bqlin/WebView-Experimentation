//
//  UIWebViewExp.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "UIWebViewExp.h"

@interface UIWebViewExp ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation UIWebViewExp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.allowsInlineMediaPlayback = YES;
    
    self.textField.delegate = self;
}

- (IBAction)go:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textField.text]];
    [self.webView loadRequest:request];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self go:nil];
    return YES;
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

@end
