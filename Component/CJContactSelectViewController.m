//
//  CJContactSelectViewController.m
//  Runner
//
//  Created by chenyn on 2019/9/27.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//  选择联系人

#import "CJContactSelectViewController.h"
#import "CJContactSelectConfig.h"
#import "NIMGroupedUsrInfo.h"
#import "CJUserSelectTableViewCell.h"
#import "CJSearchTableHeaderView.h"
#import "UIColor+YYAdd.h"
#import "XTSafeCollection.h"
#import "CJBaseMacro.h"
#import "NSArray+Cajian.h"

@interface CJContactSelectViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CJSearchHeaderDelegate>

@property (nonatomic, strong) id<NIMContactSelectConfig> config;

@property (nonatomic, strong) NSMutableArray <id <NIMGroupMemberProtocol>>*selectedUsers;

@property (nonatomic, strong) NSMutableArray <id <NIMGroupMemberProtocol>>*allUsers;

@property (nonatomic, strong) NSMutableArray *selectedIds;

/// 同步config.alreadySelectedIds获取的数据,用来渲染第一个已选中区块
@property (nonatomic, strong) NSMutableArray <id <NIMGroupMemberProtocol>>*alreadySelectedUsers;

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *sectionTitles;

@property (nonatomic, strong) NSMutableDictionary *contentDic;

@property (nonatomic, strong) UIButton *barRightBtn;

// 处于搜索状态时刷新列表以这个数据源为准
@property (nonatomic, copy) NSArray <id <NIMGroupMemberProtocol>>*currentDataSource;

// 是否处于搜索状态
@property (nonatomic, assign) BOOL inSearching;

// 当前点击的cell indexpath
@property (nonatomic, strong) NSIndexPath *crntIdxPath;

/**
 搜索栏
 */
@property (nonatomic, strong) CJSearchTableHeaderView *header;

@property (nonatomic, strong) UILabel *emptyTipLabel;

@end

@implementation CJContactSelectViewController

- (instancetype)initWithConfig:(id<NIMContactSelectConfig>)config
{
    self = [super init];
    if(self)
    {
        self.config = config;
    }
    return self;
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavgationBar];
    
    [self.view addSubview:self.header];
    [self.view addSubview:self.mTableView];
    [self configMemebrData];
}

- (void)setInSearching:(BOOL)inSearching
{
    _inSearching = inSearching;
    
    if(!_inSearching) {
        self.emptyTipLabel.hidden = YES;
        [self.view endEditing:YES];
    }
    [self.mTableView reloadData];
}

- (void)configMemebrData
{
    [self.config getContactData:^(NSDictionary *contentDic, NSArray *titles) {
        self.sectionTitles = @[].mutableCopy;
        self.contentDic = @{}.mutableCopy;
        self.selectedUsers = @[].mutableCopy;
        self.selectedIds = @[].mutableCopy;
        self.allUsers = @[].mutableCopy;
        self.alreadySelectedUsers = @[].mutableCopy;
        
        for (NSString *title in titles) {
            // 将已选中的提前
            NSArray <id <NIMGroupMemberProtocol>>*arr = [contentDic objectForKey:title];
            
            NSArray *unSlctedMembers = [arr cj_filter:^BOOL(id <NIMGroupMemberProtocol> obj) {
                return ![self.config.alreadySelectedMemberId containsObject:obj.memberId];
            }];
            
            if(!cj_empty_array(unSlctedMembers)) {
                [self.sectionTitles addObject:title];
                [self.allUsers addObjectsFromArray:unSlctedMembers];
                [self.contentDic setObject:unSlctedMembers forKey:title];
            }
            
            [arr enumerateObjectsUsingBlock:^(id <NIMGroupMemberProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.config.alreadySelectedMemberId containsObject:obj.memberId]) {
                    [self selected:obj];
                    
                    // 这个只在第一次初始化，所以不能放到selected里面
                    [self.alreadySelectedUsers addObject:obj];
                }
            }];
        }
        
        // 新增早已选中区块
        if(!cj_empty_array(self.alreadySelectedUsers)) {
            [self.sectionTitles insertObject:@"" atIndex:0];
        }
        
        [self.mTableView reloadData];
    }];
}

// 确定按钮
- (UIButton *)barRightBtn
{
    if(!_barRightBtn) {
        _barRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _barRightBtn.frame = CGRectMake(0, 0, 50, 24);
        [_barRightBtn setTitle:@"确定" forState:UIControlStateNormal];
        _barRightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_barRightBtn setBackgroundColor:[UIColor yy_colorWithHexString:@"#7BB6ED"]];
        _barRightBtn.layer.cornerRadius = 4.0;
        _barRightBtn.layer.masksToBounds = YES;
        
        [_barRightBtn addTarget:self
                         action:@selector(onConfirmBtnClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _barRightBtn;
}

// 配置导航条
- (void)configNavgationBar
{
    self.title = self.config.title;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.barRightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelBtnClick:)];
}

// 点击返回
- (void)onCancelBtnClick:(id)sender
{
    if(self.navigationController.viewControllers.firstObject != self) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

// 点击完成
- (void)onConfirmBtnClicked:(id)sender
{
    // 返回
    [self onCancelBtnClick:nil];
    
    if (self.finished) {
        NSMutableArray *selectedIds = @[].mutableCopy;
        [self.selectedUsers enumerateObjectsUsingBlock:^(id <NIMGroupMemberProtocol>_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [selectedIds addObject:obj.memberId];
        }];
        self.finished(selectedIds);
    }
}

- (UITableView *)mTableView
{    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.header.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.header.frame))
                                                   style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.backgroundColor = Main_BackgColor;
        _mTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.allowsMultipleSelection = YES;
        [_mTableView addSubview:self.emptyTipLabel];
        
        [_mTableView registerNib:[UINib nibWithNibName:@"CJUserSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"CJUserSelectTableViewCell"];
    }
    return _mTableView;
}

- (UILabel *)emptyTipLabel
{
    if(!_emptyTipLabel) {
        _emptyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
        _emptyTipLabel.textAlignment = NSTextAlignmentCenter;
        _emptyTipLabel.hidden = YES;
    }
    return _emptyTipLabel;
}

- (CJSearchTableHeaderView *)header
{
    if(!_header) {
        _header = [[CJSearchTableHeaderView alloc] initWithFrame:CGRectMake(10, TOP_TOOL_BAR_HEIGHT, SCREEN_WIDTH, 50)];
        _header.delegate = self;
    }
    return _header;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_inSearching) {
        return 1;
    }
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_inSearching) {
        return self.currentDataSource.count;
    }else if(section == 0 && !cj_empty_array(self.alreadySelectedUsers)) {
        // 已选中区块
        return self.alreadySelectedUsers.count;
    }
    NSString *title = [self.sectionTitles tn_objectAtIndex:section];
    NSArray *arr = [self.contentDic objectForKey:title];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJUserSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CJUserSelectTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id<NIMGroupMemberProtocol> user = nil;
    if(_inSearching) {
        user = [self.currentDataSource objectAtIndex:indexPath.row];
    }else if(indexPath.section == 0 && !cj_empty_array(self.alreadySelectedUsers)) {
        // 早已选中
        user = [self.alreadySelectedUsers tn_objectAtIndex:indexPath.row];
    }
    else {
        NSString *title = [self.sectionTitles tn_objectAtIndex:indexPath.section];
        NSArray *arr = [self.contentDic objectForKey:title];
        user = [arr tn_objectAtIndex:indexPath.row];
    }
    [cell configData:user config:self.config];
    if([_selectedIds containsObject:user.memberId]) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_inSearching) {
        return 0.01;
    }
    return 25;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_inSearching) {
        return @"";
    }
    return [self.sectionTitles objectAtIndex:section];
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(_inSearching) {
        return @[];
    }
    return self.sectionTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.crntIdxPath = indexPath;
    if(_inSearching) {
        id<NIMGroupMemberProtocol> user = [self.currentDataSource objectAtIndex:indexPath.row];
        [self selected:user];
        
        self.inSearching = NO;
    }else if(indexPath.section == 0 && !cj_empty_array(self.alreadySelectedUsers)) {
        id<NIMGroupMemberProtocol> user =  [self.alreadySelectedUsers tn_objectAtIndex:indexPath.row];
        
        [self selected:user];
    }
    else {
        NSString *title = [self.sectionTitles tn_objectAtIndex:indexPath.section];
        NSArray *arr = [self.contentDic objectForKey:title];
        id<NIMGroupMemberProtocol> user = [arr tn_objectAtIndex:indexPath.row];
        [self selected:user];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.crntIdxPath = indexPath;
    if(_inSearching) {
        id<NIMGroupMemberProtocol> user = [self.currentDataSource objectAtIndex:indexPath.row];
        [self deselected:user];
        
        self.inSearching = NO;
    }else if(indexPath.section == 0 && !cj_empty_array(self.alreadySelectedUsers)) {
        id<NIMGroupMemberProtocol> user =  [self.alreadySelectedUsers tn_objectAtIndex:indexPath.row];
        
        [self deselected:user];
    }
    else {
        NSString *title = [self.sectionTitles tn_objectAtIndex:indexPath.section];
        NSArray *arr = [self.contentDic objectForKey:title];
        id<NIMGroupMemberProtocol> user = [arr tn_objectAtIndex:indexPath.row];
        [self deselected:user];
    }
}

#pragma mark - CJSearchHeaderDelegate

/**
 取消选中
 
 @param item item
 */
- (void)searchHeaderDeselect:(id<NIMGroupMemberProtocol>)item
{
    // 取消列表的UI选中状态
    NSInteger section = [self.sectionTitles indexOfObject:[item groupTitle]];
    NSArray *arr = [self.contentDic objectForKey:[item groupTitle]];
    NSInteger row = [arr indexOfObject:item];
    
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.mTableView deselectRowAtIndexPath:idxPath animated:NO];
    
    // 操作数据
    [self deselected:item];
}


/**
 搜索文本变化
 
 @param key 搜索关键词
 */
- (void)searchValueChanged:(NSString *)key
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"showName CONTAINS[c] %@", key];
    self.currentDataSource = [NSMutableArray arrayWithArray:[self.allUsers filteredArrayUsingPredicate:p]];
    [self.mTableView reloadData];
    
    self.emptyTipLabel.hidden = !cj_empty_array(self.currentDataSource) || key.length == 0;
    // 搜索为空
    if(!self.emptyTipLabel.hidden) {
        NSMutableAttributedString *string =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未找到“%@”相关结果", key]];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor lightGrayColor] range:NSMakeRange(0, 4)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:Main_redColor range:NSMakeRange(4, key.length)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor lightGrayColor] range:NSMakeRange(4+key.length, 5)];
        self.emptyTipLabel.attributedText = string;
    }
}


/**
 搜索状态变化
 
 @param inSearching 是否正在搜索
 */
- (void)searchStatusChanged:(BOOL)inSearching
{
    // 重置数据源
    self.currentDataSource = @[];
    
    self.inSearching = inSearching;
}

#pragma mark - private

// 选中
- (void)selected:(id<NIMGroupMemberProtocol>)user
{
    if(!_selectedUsers) {
        _selectedUsers = @[].mutableCopy;
    }
    
    if(!_selectedIds) {
        _selectedIds = @[].mutableCopy;
    }
    
    // 确定按钮的UI
    if(cj_empty_array(_selectedUsers)) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.barRightBtn setBackgroundColor:[UIColor yy_colorWithHexString:@"#3092EE"]];
    }
    
    if(_selectedUsers.count == _config.maxSelectedNum)
    {
        [self alert];
        
        if(_selectedUsers.count == _config.maxSelectedNum)
        {
            // 达到最大限制，取消当前选中
            [self.mTableView deselectRowAtIndexPath:self.crntIdxPath
                                           animated:NO];
        }
    }else {
        [_selectedUsers addObject:user];
        [_selectedIds addObject:user.memberId];
        
        [self.header refresh:_selectedUsers];
    }
}

// 取消选中
- (void)deselected:(id <NIMGroupMemberProtocol>)user
{
    // 确定按钮的UI
    if(_selectedUsers.count == 1) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.barRightBtn setBackgroundColor:[UIColor yy_colorWithHexString:@"#7BB6ED"]];
    }
    
    [_selectedUsers removeObject:user];
    [_selectedIds removeObject:user.memberId];
    
    [self.header refresh:_selectedUsers];
}

- (void)alert
{
    NSString *title_str = [NSString stringWithFormat:@"最多只能选择%@人",@(self.config.maxSelectedNum)];
    UIAlertController *alertVC =
    [UIAlertController alertControllerWithTitle:title_str
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定"
                                                style: UIAlertActionStyleCancel
                                              handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
