//
//  CJShareAlertViewController.m
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//  分享的弹窗预览

#import "CJShareAlertViewController.h"
#import "cokit.h"
#import "CJBaseMacro.h"

@interface CJShareAlertViewController ()

@property (nonatomic, strong) NIMSession *mSession;
@property (nonatomic, strong) CJShareModel *shareModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *previewImgView;

@property (nonatomic, strong) UILabel *previewLabel;

@property (nonatomic, strong) UILabel *sessionLabel;
@property (nonatomic, strong) UIImageView *sessionAvatar;

/// 备注
@property (nonatomic, strong) UITextField *aliasInput;

/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

/// 转发按钮
@property (nonatomic, strong) UIButton *confirmButton;


@property (nonatomic, weak) id <CJShareAlertResult>interactor;

@end

@implementation CJShareAlertViewController

- (void)dealloc
{
    
}

+ (instancetype)viewControllerWithSession:(NIMSession *)session
                              shareObject:(CJShareModel *)model
                              forwordImpl:(id<CJShareAlertResult>)interactor
{
    CJShareAlertViewController *alertVC = [CJShareAlertViewController new];
    alertVC.mSession = session;
    alertVC.shareModel = model;
    alertVC.interactor = interactor;
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return alertVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self configUI];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.aliasInput action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tap];
}

- (NIMKitInfo *)sessionInfo
{
    NIMKitInfo *info;
    if(self.mSession.sessionType == NIMSessionTypeP2P) {
        info = [[NIMKit sharedKit] infoByUser:self.mSession.sessionId option:nil];
    }else {
        info = [[NIMKit sharedKit] infoByTeam:self.mSession.sessionId option:nil];
    }
    return info;
}

- (UIView *)bgView
{
    if(!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 9.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

/// 转发到的会话名字
- (UILabel *)sessionLabel
{
    if(!_sessionLabel) {
        _sessionLabel = [UILabel new];
        _sessionLabel.font = [UIFont systemFontOfSize:14];
        _sessionLabel.text = [self sessionInfo].showName;
    }
    return _sessionLabel;
}

/// 转发到会话的头像
- (UIImageView *)sessionAvatar
{
    if(!_sessionAvatar) {
        _sessionAvatar = [UIImageView new];
        _sessionAvatar.layer.cornerRadius = 3.f;
        _sessionAvatar.layer.masksToBounds = YES;
    }
    return _sessionAvatar;
}

/// 预览图片
- (UIImageView *)previewImgView
{
    if(!_previewImgView) {
        _previewImgView = [UIImageView new];
    }
    return _previewImgView;
}

/// 预览文本
- (UILabel *)previewLabel
{
    if(!_previewLabel) {
        _previewLabel = [UILabel new];
        _previewLabel.font = [UIFont systemFontOfSize:14];
        _previewLabel.numberOfLines = 2;
        _previewLabel.textColor = Main_TextGrayColor;
    }
    return _previewLabel;
}

/// 备注信息
- (UITextField *)aliasInput
{
    if(!_aliasInput) {
        _aliasInput = [UITextField new];
        _aliasInput.borderStyle = UITextBorderStyleRoundedRect;
        _aliasInput.placeholder = @"给ta留言吧～";
    }
    return _aliasInput;
}

/// 取消按钮
- (UIButton *)cancelButton
{
    if(!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消"
                       forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor systemRedColor]
                            forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(close:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

/// 确定按钮
- (UIButton *)confirmButton
{
    if(!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle: @"发送"
                        forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor systemBlueColor]
                             forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(forword:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

/// 布局计算
- (void)viewDidLayoutSubviews
{
    CGFloat horizontalPadding = 16.f;
    CGFloat sessionInfoHeight = 60.f;
    CGFloat contentHeight = 0.f;
    CGFloat textInputHeight = 33.f;
    CGFloat mariginVertical = 5.f;
    CGFloat actionHeight = 44.f;
    
    if(self.shareModel.type == CajianShareTypeImage) {
        contentHeight = 200;
    }else {
        contentHeight = 44.f;
    }
    
    CGFloat bgViewHeight = sessionInfoHeight + contentHeight + textInputHeight + actionHeight + mariginVertical * 2;
    CGFloat bgViewWidth = SCREEN_WIDTH - horizontalPadding * 2;
    self.bgView.frame = CGRectMake(horizontalPadding,
                                   (SCREEN_HEIGHT - bgViewHeight)*0.5,
                                   bgViewWidth,
                                   bgViewHeight);
    
    self.sessionAvatar.frame = CGRectMake(12, 5, 50, 50);
    
    self.sessionLabel.frame = CGRectMake(70,
                                         20,
                                         SCREEN_WIDTH - 70 - horizontalPadding,
                                         20);
    [self.sessionLabel sizeToFit];
    
    self.previewImgView.frame = CGRectMake((bgViewWidth - contentHeight)*0.5,
                                           sessionInfoHeight,
                                           contentHeight,
                                           contentHeight);
    self.previewLabel.frame = CGRectMake(12,
                                         sessionInfoHeight,
                                         self.view.frame.size.width - 24,
                                         contentHeight);
    
    self.aliasInput.frame = CGRectMake(12,
                                       bgViewHeight - actionHeight - textInputHeight +
                                       mariginVertical,
                                       bgViewWidth - 24, textInputHeight);
    
    self.cancelButton.frame = CGRectMake(0,
                                         bgViewHeight - actionHeight + mariginVertical,
                                         bgViewWidth*0.5,
                                         actionHeight);
    
    self.confirmButton.frame = CGRectMake(bgViewWidth*0.5,
                                          bgViewHeight - actionHeight + mariginVertical,
                                          bgViewWidth*0.5,
                                          actionHeight);
}

/// 添加控件
- (void)configUI {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.sessionLabel];
    [self.bgView addSubview:self.sessionAvatar];
    [self.bgView addSubview:self.aliasInput];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.confirmButton];
    
    NSString *avatarString = [self sessionInfo].avatarUrlString;
    if(avatarString) {
        co_launch(^{
            NSURL *avatarUrl = [NSURL URLWithString:avatarString];
            NSData *imgData = await([NSData async_dataWithContentsOfURL:avatarUrl]);
            self.sessionAvatar.image = await([UIImage async_imageWithData:imgData]);
        });
    }else {
        self.sessionAvatar.image = [UIImage imageNamed:@"icon_contact_groupchat"];
    }
    
    if(self.shareModel.type == CajianShareTypeImage) {
        [self.bgView addSubview:self.previewImgView];
        
        CJShareImageModel *imgModel = (CJShareImageModel *)self.shareModel;
        co_launch(^{
            self.previewImgView.image = await([UIImage async_imageWithData:imgModel.imageData]);
        });
    }else if(self.shareModel.type == CajianShareTypeText) {
        [self.bgView addSubview:self.previewLabel];
        CJShareTextModel *textModel = (CJShareTextModel *)self.shareModel;
        self.previewLabel.text = textModel.text;
    }else if(self.shareModel.type == CajianShareTypeBusinessCard) {
        [self.bgView addSubview:self.previewLabel];
        CJShareBusinessCardModel *cardModel = (CJShareBusinessCardModel *)self.shareModel;
        self.previewLabel.text = [NSString stringWithFormat:@"[个人名片]%@", cardModel.nickName];
    }
}

// 关闭
- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 转发
- (void)forword:(id)sender
{
    self.shareModel.leaveMessage = self.aliasInput.text;
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.interactor && [self.interactor respondsToSelector:@selector(shouldForword:session:)])
        {
            [self.interactor shouldForword:self.shareModel
                                   session:self.mSession];
        }
    }];
}

///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    UITextField *textView = self.aliasInput;
    CGFloat INTERVAL_KEYBOARD = 50;
    CGFloat offset = (self.bgView.frame.origin.y+ textView.frame.origin.y+textView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);

    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //将视图上移计算好的偏移
    if(offset > 0) {
        CGRect rect = self.bgView.frame;
        [UIView animateWithDuration:duration animations:^{
            self.bgView.frame = CGRectMake(rect.origin.x, rect.origin.y - offset, rect.size.width, rect.size.height);
        }];
    }
}

///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
    }];
}

@end
