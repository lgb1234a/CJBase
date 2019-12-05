//
//  CJShareModel.h
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//

#import <Foundation/Foundation.h>


@class COPromise;
@class NIMSession;
/**
 分享类型
 
 - CajianShareTextObjectType: 文本分享类型
 - CajianShareImageObjectType: 图片分享类型
 - CajianShareAppObjectType: 应用分享类型
 - CajianShareLinkObjectType: 链接分享类型
 */
typedef NS_ENUM(NSInteger, CajianShareType) {
    CajianShareTypeText = 0,
    CajianShareTypeImage,
    CajianShareTypeApp = 12,
    CajianShareTypeLink = 13,
    CajianShareEmoticonObjectType,
    CajianShareLocationObjectType,
    CajianShareVisitingCardObjectType,
    CajianShareVideoObjectType,
};

NS_ASSUME_NONNULL_BEGIN

@interface CJShareModel : NSObject

@property (nonatomic, assign, readonly) CajianShareType type;

@property (nonatomic, copy) NSString *appKey;

/// 留言,用户在转发给其他擦肩用户的时候可以额外输入的信息
@property (nonatomic, copy) NSString *leaveMessage;

- (COPromise *)share:(NIMSession *)session;

@end

@interface CJShareTextModel : CJShareModel

/// 分享的文本
@property(nonatomic, copy) NSString *text;

@end


@interface CJShareImageModel : CJShareModel

/// 二选一
/// 分享图片URL
@property(nonatomic, copy) NSString *imageUrl;
/// 分享的图片本身
@property(nonatomic, strong) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
