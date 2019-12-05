//
//  CJShareAlertViewController.h
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//

#import <UIKit/UIKit.h>
#import <NIMKit.h>
#import "CJShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CJShareAlertResult <NSObject>

/// 点击了转发按钮
/// @param model 数据
/// @param session 会话
- (void)shouldForword:(CJShareModel *)model
              session:(NIMSession *)session;

@end

@interface CJShareAlertViewController : UIViewController

+ (instancetype)viewControllerWithSession:(NIMSession *)session
                              shareObject:(CJShareModel *)model
                              forwordImpl:(id<CJShareAlertResult>)interactor;

@end

NS_ASSUME_NONNULL_END
