//
//  CJPopOverMenuView.h
//  CJBase
//
//  Created by chenyn on 2019/12/31.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJPopoverPosition) {
    CJPopoverPositionUp = 1,
    CJPopoverPositionDown,
};

typedef NS_ENUM(NSUInteger, CJPopoverMaskType) {
    CJPopoverMaskTypeBlack,
    CJPopoverMaskTypeNone,  // overlay does not respond to touch
};

NS_ASSUME_NONNULL_BEGIN

@interface CJPopOverMenuView : UIView

+ (instancetype)popover;

/**
 *  The contentView positioned in container, default is zero;
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  The popover arrow size, default is {10.0, 10.0};
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  The popover corner radius, default is 7.0;
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  The popover animation show in duration, default is 0.4;
 */
@property (nonatomic, assign) NSTimeInterval animationIn;


/**
 *  The popover animation dismiss duration, default is 0.3;
 */
@property (nonatomic, assign) NSTimeInterval animationOut;


/**
 *  The background of the popover, default is DXPopoverMaskTypeBlack;
 */
@property (nonatomic, assign) CJPopoverMaskType maskType;

/**
 *  If maskType does not satisfy your need, use blackoverylay to control the touch
 * event(userInterfaceEnabled) for
 * background color
 */
@property (nonatomic, strong, readonly) UIControl *blackOverlay;


/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow
 * and atView. Note:
 * this value is invalid when popover show using the atPoint API
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;

/**
 *  The callback when popover did show in the containerView
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView;
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

/**
*  Show API
*
*  @param point         the point in the container coordinator system.
*  @param position      stay up or stay down from the showAtPoint
*  @param contentView   the contentView to show
*  @param containerView the containerView to contain
*/
- (void)showAtPoint:(CGPoint)point
     popoverPostion:(CJPopoverPosition)position
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView;

/**
*  Lazy show API        The show point will be caluclated for you, try it!
*
*  @param atView        The view to show at
*  @param position      stay up or stay down from the atView, if up or down size is not enough for
* contentView, then it
* will be set correctly auto.
*  @param contentView   the contentView to show
*  @param containerView the containerView to contain
*/
- (void)showAtView:(UIView *)atView
    popoverPostion:(CJPopoverPosition)position
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView;


- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
