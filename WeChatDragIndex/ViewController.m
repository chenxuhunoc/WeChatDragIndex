//
//  ViewController.m
//  WeChatDragIndex
//
//  Created by XunCheng_Jack on 2019/7/25.
//  Copyright © 2019 XunCheng. All rights reserved.
//

#import "ViewController.h"
#import "XCLeagueFilterCell.h"
#import "UITableView+CCPIndexView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *filterTableView;

@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, copy)NSArray *groupNameArr;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self loadData];
	[self initUI];
}

- (void)loadData {
	// 暂时数据 删除
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPathString = [bundle pathForResource:@"team" ofType:@"plist"];
	
	self.dataDic = [[NSDictionary alloc] initWithContentsOfFile:plistPathString];
	self.groupNameArr = [[self.dataDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)initUI {
	[self.view addSubview:self.filterTableView];
}

- (UITableView *)filterTableView {
	if (!_filterTableView) {
		_filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, [UIScreen   mainScreen].bounds.size.height-55) style:UITableViewStyleGrouped];
		_filterTableView.delegate = self;
		_filterTableView.dataSource = self;
		_filterTableView.backgroundColor = [UIColor colorWithRed:17 green:28 blue:38 alpha:1.0];
		_filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_filterTableView.tableFooterView = [[UIView alloc] init];
		_filterTableView.userInteractionEnabled = YES;
		_filterTableView.sectionIndexColor = [UIColor redColor];
		_filterTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
		[_filterTableView ccpIndexView];
	}
	return _filterTableView;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
	return self.view;
}

#pragma mark - UITableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	static NSString *identfier = @"XCLeagueFilterCell";
	XCLeagueFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
	if (cell == nil) {
		cell = [[XCLeagueFilterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identfier];
	}
	NSString *key = self.groupNameArr[indexPath.section];
	NSArray *valueArr = [self.dataDic objectForKey:key];
	cell.titlelabel.text = [NSString stringWithFormat:@"%@", valueArr[indexPath.row]];
	cell.deatilLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
	// 第一行显示
	if (indexPath.row == 0) {
		cell.topLineLabel.hidden = NO;
	} else {
		cell.topLineLabel.hidden = YES;
	}
	return cell;
}

#pragma mark 索引列点击事件
// 手指滑动及点击字母相应的代理
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
	//点击索引，列表跳转到对应索引的行
	if ([title isEqualToString:@"热门"]) {
		return self.groupNameArr.count;
	}
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[XCProgressHUD showSuccess:title];
	return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.groupNameArr objectAtIndex:section];
}

// 索引标题就是右侧的A-Z 字母
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray *listTitlesArray = [[NSMutableArray alloc] initWithCapacity:[self.groupNameArr count]];
	for (NSString *item in self.groupNameArr) {
		[listTitlesArray addObject:item];
	}
	return listTitlesArray;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *key = self.groupNameArr[section];
	NSArray *valueArr = [self.dataDic objectForKey:key];
	return valueArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.groupNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

