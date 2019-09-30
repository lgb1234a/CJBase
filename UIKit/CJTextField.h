//
//  CJTextField.h
//  CJBase
//
//  Created by chenyn on 2019/9/30.
//

#import <UIKit/UIKit.h>

@protocol CJTextFieldInput <NSObject>

@optional
- (void)deleteBackward:(BOOL)beforeHasText;

@end
NS_ASSUME_NONNULL_BEGIN

@interface CJTextField : UITextField

@property (nonatomic, assign) id<CJTextFieldInput> cjInputDelegate;

@end

NS_ASSUME_NONNULL_END
