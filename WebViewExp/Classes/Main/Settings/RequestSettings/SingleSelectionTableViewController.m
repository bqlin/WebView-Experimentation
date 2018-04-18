//
//  SingleSelectionTableViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "SingleSelectionTableViewController.h"
#import "BqUtil.h"

static NSString * const CellReuseIdentifier = @"reuseIdentifier";

@interface SingleSelectionTableViewController ()

@end

@implementation SingleSelectionTableViewController

#pragma mark - property

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	_selectedIndex = selectedIndex;
	if (self.selectedIndexChangeHandler) self.selectedIndexChangeHandler(self);
}

#pragma mark - view controller

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
	
	self.tableView.tableHeaderView = [UIView new];
	self.tableView.tableFooterView = [UIView new];
	//self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
	cell.textLabel.text = self.choices[indexPath.row].title;
	if (self.selectedIndex == indexPath.row) {
		//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
	cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 获取需要的数据
	NSInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
	
	// 取消选中
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	__weak typeof(self) weakSelf = self;
	void (^selectAction)(void) = ^ {
		for (int i = 0; i < rowCount; i ++) {
			if (indexPath.row == i) continue;
			NSIndexPath *indexPathx = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
			UITableViewCell *cellx = [tableView cellForRowAtIndexPath:indexPathx];
			if (cellx.accessoryType == UITableViewCellAccessoryCheckmark) cellx.accessoryType = UITableViewCellAccessoryDetailButton;
		}
		// 进行单选
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		// 更新数据
		weakSelf.selectedIndex = indexPath.row;
	};
	
	SingleSelectionItem *item = self.choices[indexPath.row];
	if (item.disable) {
		[self showWarningAlertWithMessage:item.detail cancelHandler:nil continueHandler:selectAction];
		return;
	}
	
	selectAction();
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	SingleSelectionItem *item = self.choices[indexPath.row];
	[self showDetailAlertWithItem:item sender:[tableView cellForRowAtIndexPath:indexPath].contentView];
}

#pragma mark - private

- (void)showWarningAlertWithMessage:(NSString *)message cancelHandler:(void (^)(void))cancelHandler continueHandler:(void (^)(void))continueHandler {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"⚠️警告" message:message preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		if (cancelHandler) cancelHandler();
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		if (continueHandler) continueHandler();
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)showDetailAlertWithItem:(SingleSelectionItem *)item sender:(UIView *)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:item.title message:item.detail preferredStyle:UIAlertControllerStyleActionSheet];
	[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	if (IS_IPAD) {
		UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
		popPresenter.sourceView = sender;
		popPresenter.sourceRect = sender.bounds;
		popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
	}
	[self presentViewController:alertController animated:YES completion:nil];
}

@end
