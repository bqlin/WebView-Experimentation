//
//  HeaderFieldViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/17.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "HeaderFieldViewController.h"
#import "AppDelegate.h"
#import "KeyValueFieldCell.h"
#import "BqUtil.h"

NS_INLINE NSString *DescriptionFromKeyValueItems(NSArray<KeyValueItem *> *items) {
	if (!items.count) return nil;
	NSMutableString *description = [NSMutableString string];
	for (KeyValueItem *item in items) {
		[description appendFormat:@"%@,\n", item];
	}
	[description deleteCharactersInRange:NSMakeRange(description.length - 2, 2)];
	return description;
}

@interface HeaderFieldViewController ()

@property (nonatomic, strong) NSMutableArray<KeyValueItem *> *headerFieldItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeButton;
@property (nonatomic, strong) UIBarButtonItem *selectAllButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;

@end

@implementation HeaderFieldViewController

#pragma mark - property

- (void)setHeaderFields:(NSDictionary *)headerFields {
	_headerFields = headerFields;
	if (!headerFields) headerFields = @{};
	NSArray *headerFieldKeys = [headerFields keysSortedByValueUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
		return [key1 compare:key2];
	}];
	NSMutableArray *headerFieldItems = [NSMutableArray array];
	for (NSString *key in headerFieldKeys) {
		KeyValueItem *item = [[KeyValueItem alloc] init];
		item.key = key;
		item.value = headerFields[key];
		[headerFieldItems addObject:item];
	}
	_headerFieldItems = headerFieldItems;
}

- (UIBarButtonItem *)selectAllButton {
	if (!_selectAllButton) {
		_selectAllButton = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAllAction:)];
	}
	return _selectAllButton;
}
- (UIBarButtonItem *)deleteButton {
	if (!_deleteButton) {
		_deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAction:)];
		_deleteButton.tintColor = [UIColor redColor];
	}
	return _deleteButton;
}

#pragma mark - view controller

- (void)dealloc {
	NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[self updateHeaderFields];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self updateBarButton];
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
	NSInteger number = self.headerFieldItems.count;
	[self updateEmptyUI:number == 0];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyValueFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerFieldCell" forIndexPath:indexPath];
	
	KeyValueItem *item = self.headerFieldItems[indexPath.row];
	cell.item = item;
    
    return cell;
}

#pragma mark - table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.headerFieldItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self setEditing:NO animated:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self updateDeleteButton];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self updateDeleteButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private

#pragma mark 更新UI

- (void)updateBarButton {
	self.removeButton.title = self.editing ? @"✖️" : @"➖";
	if (!self.editing || [self.tableView numberOfRowsInSection:0] == 0) {
		self.navigationItem.leftBarButtonItem = nil;
		return;
	}
	[self updateDeleteButton];
}

- (void)updateDeleteButton {
	if (!self.tableView.allowsMultipleSelectionDuringEditing) return;
	NSInteger selectedCount = self.tableView.indexPathsForSelectedRows.count;
	if (selectedCount > 0) {
		self.navigationItem.leftBarButtonItem = self.deleteButton;
		self.deleteButton.title = [NSString stringWithFormat:@"删除(%zd)", selectedCount];
	} else {
		self.navigationItem.leftBarButtonItem = self.selectAllButton;
	}
}

- (void)updateEmptyUI:(BOOL)empty {
	if (self.editing && empty) {
		[self setEditing:NO animated:YES];
	}
	self.removeButton.enabled = !empty;
	self.tableView.tableFooterView.hidden = !empty;
}

- (void)updateHeaderFields {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	for (KeyValueItem *item in self.headerFieldItems) {
		NSString *itemKey = item.key;
		NSString *itemValue = item.value;
		if (!itemKey || !itemValue) continue;
		dic[item.key] = item.value;
	}
	//NSString *key = @"headerFieldDic";
	//[self willChangeValueForKey:key];
	_headerFields = dic;
	//[self didChangeValueForKey:key];
	if (self.headerFieldsChnageHandler) self.headerFieldsChnageHandler(self);
}

#pragma mark - 剪贴板

- (NSArray *)itemsFromPraste {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	NSString *pastedString = pasteboard.string;
	pastedString = [pastedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *pastedStrings = [pastedString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableArray *items = [NSMutableArray array];
	for (NSString *substring in pastedStrings) {
		// 替换
		NSString *newSubstring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		newSubstring = [newSubstring stringByReplacingOccurrencesOfString:@"\\s*:\\s*" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, newSubstring.length)];
		//NSLog(@"newSubstring: %@", newSubstring);
		// 拆分赋值
		NSArray *keyValueStrings = [newSubstring componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		if (keyValueStrings.count != 2) continue;
		
		KeyValueItem *item = [KeyValueItem item];
		item.key = keyValueStrings[0];
		item.value = keyValueStrings[1];
		[items addObject:item];
	}
	
	return items;
}

- (void)addHeaderFieldsWithItems:(NSArray<KeyValueItem *> *)items {
	for (KeyValueItem *item in items) {
		if ([self.headerFieldItems containsObject:item]) continue;
		[self.headerFieldItems addObject:item];
	}
	[self.tableView reloadData];
}

- (void)clearAll {
	[self.headerFieldItems removeAllObjects];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showPrasteAlert {
	NSArray *items = [self itemsFromPraste];
	NSString *message = DescriptionFromKeyValueItems(items);
	NSString *title = items.count ? @"是否添加剪贴板识别的请求头信息？" : @"无法识别剪贴内容";
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	__weak typeof(self) weakSelf = self;
	if (items.count) [alertController addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf addHeaderFieldsWithItems:items];
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - action

- (IBAction)addAction:(id)sender {
	[self.headerFieldItems addObject:[KeyValueItem item]];
	NSIndexPath *endIndePath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[endIndePath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (IBAction)removeAction:(UIBarButtonItem *)sender {
	self.tableView.allowsMultipleSelectionDuringEditing = !self.editing;
	[self setEditing:!self.editing animated:YES];
}

- (void)selectAllAction:(id)sender {
	NSInteger rowCount = [self.tableView numberOfRowsInSection:0];
	for (int i = 0; i < rowCount; i++) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
	}
	[self updateBarButton];
}

- (void)deleteAction:(id)sender {
	NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
	
	// 操作数据源
	NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
	for (NSIndexPath *selectionIndex in selectedRows) {
		[indicesOfItemsToDelete addIndex:selectionIndex.row];
	}
	[self.headerFieldItems removeObjectsAtIndexes:indicesOfItemsToDelete];
	
	// 删除所选的行
	[self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
	
	// 恢复状态
	[self setEditing:NO animated:YES];
	self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (IBAction)pasteAction:(id)sender {
	BOOL donotShowInfo = NO;
	NSString *donotShowInfoKey = @"donotShowInfo";
	__block NSMutableDictionary *tempDic = [(AppDelegate *)[UIApplication sharedApplication].delegate tempDictionary];
	if (tempDic[donotShowInfoKey]) {
		donotShowInfo = [tempDic[donotShowInfoKey] boolValue];
	}
	if (donotShowInfo) {
		[self showPrasteAlert];
		return;
	}
	NSString *infoMessage = @"程序可识别剪贴板每行内容为一对请求头信息，每行内容需使用“:”分隔键与值，例如：“KEY : VALUE”。";
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"从剪贴板识别" message:infoMessage preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"不再显示" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		tempDic[donotShowInfoKey] = @(YES);
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	__weak typeof(self) weakSelf = self;
	[alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
		[weakSelf showPrasteAlert];
	}]];
	[self presentViewController:alertController animated:YES completion:^{}];
}

- (IBAction)clearAction:(UIBarButtonItem *)sender {
	if (![self.tableView numberOfRowsInSection:0]) return;
	UIView *senderView = [sender valueForKey:@"view"];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清空请求头信息" message:@"是否清空所有请求头信息？" preferredStyle:UIAlertControllerStyleActionSheet];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	__weak typeof(self) weakSelf = self;
	[alertController addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf clearAll];
	}]];
	if (IS_IPAD) {
		UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
		popPresenter.sourceView = senderView;
		popPresenter.sourceRect = senderView.bounds;
		popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
	}
	[self presentViewController:alertController animated:YES completion:nil];
}

@end
