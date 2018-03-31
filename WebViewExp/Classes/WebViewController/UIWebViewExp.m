//
//  UIWebViewExp.m
//  WebViewExp
//
//  Created by LinBq on 16/11/2.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "UIWebViewExp.h"

@interface UIWebViewExp ()<UITextFieldDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation UIWebViewExp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.allowsInlineMediaPlayback = YES;
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.searchBarStyle = UISearchBarStyleMinimal;
	searchBar.text = @"https://www.baidu.com/";
	searchBar.delegate = self;
	
	UITextField *textField = [[UITextField alloc] init];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	
	self.navigationItem.titleView = searchBar;
	
    self.textField.delegate = self;
}


- (IBAction)go:(id)sender {
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchBar.text]];
	[self.webView loadRequest:request];
}


@end
