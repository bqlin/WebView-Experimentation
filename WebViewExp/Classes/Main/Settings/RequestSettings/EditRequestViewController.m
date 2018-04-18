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
#import "BqInputAccessoryView.h"

typedef NS_ENUM(NSInteger, BqRequestSettingType) {
	BqRequestSettingTypeHeaderFields,
	BqRequestSettingTypeHttpBody,
	BqRequestSettingTypeHttpMethod,
	BqRequestSettingTypeTimeout,
	BqRequestSettingTypeCellularAccess,
	BqRequestSettingTypeCachePolicy
};

static NSArray *CachePolicyItems() {
	NSMutableArray<SingleSelectionItem *> *items = [NSMutableArray array];
	[items addObject:[SingleSelectionItem itemWithTitle:@"UseProtocolCachePolicy"]];
	items.lastObject.detail = @"默认的缓存策略，其行为是由协议指定的针对该协议最好的实现方式。";
	[items addObject:[SingleSelectionItem itemWithTitle:@"ReloadIgnoringCacheData"]];
	items.lastObject.detail = @"从服务端加载数据，完全忽略缓存。";
	[items addObject:[SingleSelectionItem itemWithTitle:@"ReturnCacheDataElseLoad"]];
	items.lastObject.detail = @"使用缓存数据，忽略其过期时间；只有在没有缓存版本的时候才从源端加载数据。";
	[items addObject:[SingleSelectionItem itemWithTitle:@"ReturnCacheDataDontLoad"]];
	items.lastObject.detail = @"只使用缓存数据，如果不存在缓存，请求失败，直接导致崩溃；用于没有建立网络连接离线模式。";
	items.lastObject.disable = YES;
	return items.copy;
}

@interface EditRequestViewController ()

@property (weak, nonatomic) IBOutlet UITextView *uaTextView;
@property (weak, nonatomic) IBOutlet UILabel *headerFieldDetailLabel;
@property (weak, nonatomic) IBOutlet UITextView *httpBodyTextView;
@property (weak, nonatomic) IBOutlet UITextField *httpMethodTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeoutTextField;
@property (weak, nonatomic) IBOutlet UISwitch *allowsCellularSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cachcePolicyDetailLabel;
@property (nonatomic, strong) IBOutlet BqInputAccessoryView *httpMethodInputAccessoryView;

@property (nonatomic, strong) RequestSettings *settings;

@end

@implementation EditRequestViewController

#pragma mark - property

- (RequestSettings *)settings {
	if (!_settings) {
		_settings = [Settings sharedSettings].requestSettings;
		//Settings *settings = [Settings sharedSettings];
		//if (settings.requestSettings) {
		//	_settings = settings.requestSettings;
		//} else {
		//	_settings = [[RequestSettings alloc] init];
		//	settings.requestSettings = _settings;
		//}
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
	self.httpMethodTextField.inputAccessoryView = self.httpMethodInputAccessoryView;
	self.httpMethodInputAccessoryView.textField = self.httpMethodTextField;
	self.httpMethodInputAccessoryView.inputKeys = @[@"GET", @"POST"];
	[self updateUIFromSetting];
}

- (void)updateUIFromSetting {
	self.uaTextView.text = self.settings.globalUserAgent;
	self.httpBodyTextView.text = self.settings.httpBody;
	self.timeoutTextField.text = @(self.settings.timeoutInterval).description;
	self.httpMethodTextField.text = self.settings.httpMethod;
	self.allowsCellularSwitch.on = self.settings.allowsCellularAccess;
	[self updateHeaderFieldUI];
	[self updateCachcePolicyUI];
}

- (void)updateHeaderFieldUI {
	NSString *text = nil;
	if (self.settings.headerFields.count) {
		text = [NSString stringWithFormat:@"%zd", self.settings.headerFields.count];
	} else {
		text = @"无";
	}
	self.headerFieldDetailLabel.text = text;
}
- (void)updateCachcePolicyUI {
	self.cachcePolicyDetailLabel.text = [[CachePolicyItems() objectAtIndex:self.settings.cachePolicy] title];
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
				[weakSelf updateHeaderFieldUI];
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
				SingleSelectionTableViewController *vc = [[SingleSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				vc.choices = CachePolicyItems();
				vc.selectedIndex = self.settings.cachePolicy;
				vc.title = @"缓存策略";
				__weak typeof(self) weakSelf = self;
				vc.selectedIndexChangeHandler = ^(SingleSelectionTableViewController *__weak controller) {
					weakSelf.settings.cachePolicy = controller.selectedIndex;
					dispatch_async(dispatch_get_main_queue(), ^{
						[weakSelf updateCachcePolicyUI];
					});
				};
				[self showViewController:vc sender:cell];
			} break;
			default:{} break;
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
