//
//  SingleSelectionTableViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/16.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "SingleSelectionTableViewController.h"
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
	cell.textLabel.text = self.choices[indexPath.row];
	if (self.selectedIndex == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 获取需要的数据
	NSInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
	
	// 取消选中
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// 进行单选
	for (int i = 0; i < rowCount; i ++) {
		if (indexPath.row == i) continue;
		NSIndexPath *indexPathx = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
		UITableViewCell *cellx = [tableView cellForRowAtIndexPath:indexPathx];
		if (cellx.accessoryType == UITableViewCellAccessoryCheckmark) cellx.accessoryType = UITableViewCellAccessoryNone;
	}
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	// 更新数据
	self.selectedIndex = indexPath.row;
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
