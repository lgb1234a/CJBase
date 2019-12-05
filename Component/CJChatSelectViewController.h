//
//  CJChatSelectViewController.h
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//

#import <UIKit/UIKit.h>
#import <NIMKit.h>


@class CJChatSelectViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol CJChatSelectResult <NSObject>

/// 选择了会话
/// @param session 会话信息

/// 选择了会话
/// @param session 会话信息
/// @param vc 控制器
- (void)didSelectedSession:(NIMRecentSession *)session
                      from:(CJChatSelectViewController *)vc;


/// 创建了新的聊天
/// @param rcntSession 会话信息
/// @param vc 控制器
- (void)shareToNewSession:(NIMSession *)rcntSession
                     from:(CJChatSelectViewController *)vc;

@end

@interface CJChatSelectViewController : UIViewController

@property (nonatomic, copy) void(^completion)(NIMSession *);

+ (instancetype)viewControllerWithDelegate:(id <CJChatSelectResult>)from;

@end

NS_ASSUME_NONNULL_END
