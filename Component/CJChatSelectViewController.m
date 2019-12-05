//
//  CJChatSelectViewController.m
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//  选择聊天

#import "CJChatSelectViewController.h"
#import "CJBaseMacro.h"
#import "XTSafeCollection.h"
#import "cokit.h"
#import "CJContactSelectViewController.h"
#import "UIViewController+HUD.h"

@interface CJChatSelectTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NIMSession *mSession;

@end

@implementation CJChatSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.imgView = [UIImageView new];
    self.imgView.layer.cornerRadius = 3.f;
    self.imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imgView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellH = self.frame.size.height;
    CGFloat cellW = self.frame.size.width;
    CGFloat padding = 10.f;
    CGSize avatarSize = CGSizeMake(cellH - padding*2, cellH - padding*2);
    self.imgView.frame = CGRectMake(22, padding, avatarSize.width, avatarSize.height);
    self.nameLabel.frame = CGRectMake(22+avatarSize.width+8,
                             padding+avatarSize.height*0.5 - 10,
                             cellW - (12+avatarSize.width+5),
                             20.f);
}

/// 配置数据
- (void)configModel:(NIMSession *)session
{
    if(self.mSession == session) {
        return;
    }
    
    self.mSession = session;
    NIMKitInfo *info = [[NIMKit sharedKit] infoByTeam:session.sessionId option:nil];
    self.imgView.image = info.avatarImage;
    
    if(info.avatarUrlString) {
        co_launch(^{
            NSURL *url = [NSURL URLWithString:info.avatarUrlString];
            NSData *data = await([NSData async_dataWithContentsOfURL:url]);
            UIImage *image = await([UIImage async_imageWithData:data]);
            self.imgView.image = image;
        });
    }else {
        self.imgView.image = [UIImage imageNamed:@"icon_contact_groupchat"];
    }
    
    
    self.nameLabel.text = info.showName;
}

@end

@interface CJChatSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<NIMRecentSession *> *rcntSessions;

@property (nonatomic, weak) id <CJChatSelectResult> delegate;

@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation CJChatSelectViewController

- (void)dealloc
{
    
}

+ (instancetype)viewControllerWithDelegate:(id <CJChatSelectResult>)from
{
    CJChatSelectViewController *vc = [[super alloc] init];
    vc.delegate = from;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择一个聊天";
    
    self.rcntSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions.copy;
    
    [self buildNavigationBar];
    [self buildTableView];
}

- (void)buildNavigationBar
{
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close addTarget:self
              action:@selector(close:)
    forControlEvents:UIControlEventTouchUpInside];
    [close setImage:[UIImage imageNamed:@"icon_navi_back"] forState:UIControlStateNormal];
    [close sizeToFit];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:close];
    
    self.navigationItem.leftBarButtonItems  = @[closeItem];
}

- (void)buildTableView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_TOOL_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_TOOL_BAR_HEIGHT)  style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 22, 0, 0);
    
    [self.mTableView registerClass:CJChatSelectTableViewCell.class
            forCellReuseIdentifier:@"CJChatSelectTableViewCell"];
    
    [self.view addSubview:self.mTableView];
}

- (void)close:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

#pragma mark --- UITableViewDelegate, UITableViewDataSource ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    }else {
        return self.rcntSessions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0) {
        cell = [UITableViewCell new];
        cell.textLabel.text = @"创建新的聊天";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CJChatSelectTableViewCell" forIndexPath:indexPath];
        NIMRecentSession *rs = [self.rcntSessions tn_objectAtIndex:indexPath.row];
        [(CJChatSelectTableViewCell *)cell configModel:rs.session];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return nil;
    }else {
        return @"最近聊天";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.00001;
    }else {
        return 15.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.00001;
    }else {
        return 40.f;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        /// 创建新聊天
        [self selectMembers];
    }else {
        /// 点击会话
        NIMRecentSession *session = [self.rcntSessions tn_objectAtIndex:indexPath.row];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSession:from:)])
        {
            [self.delegate didSelectedSession:session from:self];
        }
    }
}


#pragma mark ---- private ----

- (void)selectMembers
{
    NIMContactFriendSelectConfig *config = [NIMContactFriendSelectConfig new];
    config.needMutiSelected = YES;
    
    CJContactSelectViewController *selectorVc = [[CJContactSelectViewController alloc] initWithConfig:config];
    
    __weak typeof(self) weakSelf = self;
    selectorVc.finished = ^(NSArray * _Nonnull ids) {
        // 选择✅
        [weakSelf createGroup:ids];
    };
    [self.navigationController pushViewController:selectorVc
                                         animated:YES];
}

- (void)createGroup:(NSArray <NSString *>*)ids
{
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.type       = NIMTeamTypeAdvanced;
    option.joinMode   = NIMTeamJoinModeNoAuth;
    option.beInviteMode = NIMTeamBeInviteModeNoAuth;
    option.inviteMode   = NIMTeamInviteModeAll;
    
    
    NSMutableArray *names = @[[[NIMKit sharedKit] infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:nil].showName].mutableCopy;
    // 获取成员名字
    [ids enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [names addObject:[[NIMKit sharedKit] infoByUser:obj option:nil].showName];
    }];
    
    option.name = [names componentsJoinedByString:@"、"];
    [[NIMSDK sharedSDK].teamManager createTeam:option
                                         users:ids
                                    completion:^(NSError * __nullable error, NSString * __nullable teamId, NSArray<NSString *> * __nullable failedUserIds){
        if(!error && teamId) {
            // 创建成功
            NIMSession *session = [NIMSession session:teamId
                                                 type:NIMSessionTypeTeam];
            if(self.delegate && [self.delegate respondsToSelector:@selector(shareToNewSession:from:)])
            {
                [self.delegate shareToNewSession:session from:self];
            }
        }else {
            [UIViewController showError:@"创建群聊失败!"];
        }
    }];
}

@end
