//
//  UIView+CJXib.m
//  CJBase
//
//  Created by chenyn on 2019/9/29.
//

#import "UIView+CJXib.h"
#import <objc/runtime.h>

@implementation UIView (CJXib)

- (CGFloat)layerCornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius
{
    self.layer.cornerRadius = layerCornerRadius;
}

- (BOOL)layerMasksToBounds
{
    return self.layer.masksToBounds;
}

- (void)setLayerMasksToBounds:(BOOL)layerMasksToBounds
{
    self.layer.masksToBounds = layerMasksToBounds;
}

@end
