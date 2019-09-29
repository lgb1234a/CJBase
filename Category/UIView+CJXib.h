//
//  UIView+CJXib.h
//  CJBase
//
//  Created by chenyn on 2019/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJXib)

@property (nonatomic, assign)IBInspectable CGFloat layerCornerRadius;
@property (nonatomic, assign)IBInspectable BOOL layerMasksToBounds;

@end

NS_ASSUME_NONNULL_END
