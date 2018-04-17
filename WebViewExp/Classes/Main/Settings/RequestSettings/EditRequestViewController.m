//
//  EditRequestViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "EditRequestViewController.h"
#import "Settings.h"
#import "SingleSelectionTableViewController.h"
#import "HeaderFieldViewController.h"

typedef NS_ENUM(NSInteger, BqRequestSettingType) {
	BqRequestSettingTypeHeaderFields,
	BqRequestSettingTypeHttpBody,
	BqRequestSettingTypeHttpMethod,
	BqRequestSettingTypeTimeout,
	BqRequestSettingTypeCellularAccess,
	BqRequestSettingTypeCachePolicy
};

static NSString *NSStringFromNSURLRequestCachePolicy(NSURLRequestCachePolicy cachePolicy) {
	switch (cachePolicy) {
		case NSURLRequestReloadIgnoringCacheData:{
			return @"ReloadIgnoringCacheData";
		} break;
		case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:{
			return @"ReloadIgnoringLocalAndRemoteCacheData";
		} break;
		case NSURLRequestReloadRevalidatingCacheData:{
			return @"ReloadRevalidatingCacheData";
		} break;
		case NSURLRequestReturnCacheDataDontLoad:{
			return @"ReturnCacheDataDontLoad";
		} break;
		case NSURLRequestReturnCacheDataElseLoad:{
			return @"ReturnCacheDataElseLoad";
		} break;
		case NSURLRequestUseProtocolCachePolicy:{
			return @"UseProtocolCachePolicy";
		} break;
	}
}

@interface EditRequestViewController ()

@property (weak, nonatomic) IBOutlet UITextView *uaTextView;
@property (weak, nonatomic) IBOutlet UILabel *headerFieldDetailLabel;
@property (weak, nonatomic) IBOutlet UITextView *httpBodyTextView;
@property (weak, nonatomic) IBOutlet UITextField *httpMethodTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeoutTextField;
@property (weak, nonatomic) IBOutlet UISwitch *allowsCellularSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cahcePolicyDetailLabel;

@property (nonatomic, strong) RequestSettings *settings;

@end

@implementation EditRequestViewController

#pragma mark - property

- (RequestSettings *)settings {
	if (!_settings) {
		Settings *settings = [Settings sharedSettings];
		if (settings.request) {
			_settings = settings.request;
		} else {
			_settings = [[RequestSettings alloc] init];
			settings.request = _settings;
		}
	}
	return _settings;
}

#pragma mark - view controller

- (void)dealloc {
	[[Settings sharedSettings] writeSettings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupUI];
}

- (void)setupUI {
	self.uaTextView.backgroundColor = self.httpBodyTextView.backgroundColor = [UIColor clearColor];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
	label.text = @"s";
	label.textColor = [UIColor darkGrayColor];
	self.timeoutTextField.rightView = label;
	self.timeoutTextField.rightViewMode = UITextFieldViewModeAlways;
	
//	self.httpMethodTextField.inputView = view;
	[self updateUIFromSetting];
}

- (void)updateUIFromSetting {
	self.uaTextView.text = self.settings.globalUserAgent;
	self.httpBodyTextView.text = self.settings.httpBody;
	self.timeoutTextField.text = @(self.settings.timeoutInterval).description;
	self.httpMethodTextField.text = self.settings.httpMethod;
	self.allowsCellularSwitch.on = self.settings.allowsCellularAccess;
}
- (void)updateSettingFromUI {
	self.settings.globalUserAgent = self.uaTextView.text;
	self.settings.httpBody = self.httpBodyTextView.text;
	if (!self.httpBodyTextView.text.length) {
		self.settings.httpBody = nil;
	}
	self.settings.timeoutInterval = self.timeoutTextField.text.doubleValue;
	self.settings.httpMethod = self.httpMethodTextField.text;
	self.settings.allowsCellularAccess = self.allowsCellularSwitch.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[HeaderFieldViewController class]]) {
		HeaderFieldViewController *vc = segue.destinationViewController;
		vc.headerFields = self.settings.headerFields;
		__weak typeof(self) weakSelf = self;
		vc.headerFieldsChnageHandler = ^(HeaderFieldViewController *__weak controller) {
			weakSelf.settings.headerFields = controller.headerFields;
			dispatch_async(dispatch_get_main_queue(), ^{
				NSString *text = nil;
				if (controller.headerFields.count) {
					text = [NSString stringWithFormat:@"%zd", controller.headerFields.count];
				} else {
					text = @"无";
				}
				weakSelf.headerFieldDetailLabel.text = text;
			});
		};
	}
}

#pragma mark - action

- (IBAction)resetAction:(UIBarButtonItem *)sender {
	__weak typeof(self) weakSelf = self;
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恢复默认配置" message:@"是否恢复所有请求配置到默认值？" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf.settings restoreToDefault];
		[weakSelf updateUIFromSetting];
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
	[self updateSettingFromUI];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearHttpBodyAction:(id)sender {
	self.httpBodyTextView.text = nil;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	BOOL hasInputView = NO;
	for (UIView *subview in cell.contentView.subviews) {
		if ([subview isKindOfClass:[UITextView class]] || [subview isKindOfClass:[UITextField class]]) {
			[subview becomeFirstResponder];
			hasInputView = YES;
			break;
		}
	}
	if (indexPath.section == 1) {
		switch (indexPath.row) {
			case BqRequestSettingTypeHeaderFields:{
				
			} break;
			case BqRequestSettingTypeCachePolicy:{
				NSMutableArray *cacheChoises = [NSMutableArray array];
				for (int i = 0; i < NSURLRequestReloadRevalidatingCacheData; i++) {
					[cacheChoises addObject:NSStringFromNSURLRequestCachePolicy(i)];
				}
				SingleSelectionTableViewController *vc = [[SingleSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				vc.choices = cacheChoises;
				vc.selectedIndex = self.settings.cachePolicy;
				vc.title = @"缓存策略";
				[self showViewController:vc sender:cell];
			} break;
			default:{} break;
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
