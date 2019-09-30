//
//  CJTextField.m
//  CJBase
//
//  Created by chenyn on 2019/9/30.
//

#import "CJTextField.h"

@implementation CJTextField

- (void)deleteBackward
{
    BOOL deleteBeforeHasText = [super hasText];
    [super deleteBackward];
    
    if(self.cjInputDelegate && [self.cjInputDelegate respondsToSelector:@selector(deleteBackward:)])
    {
        [self.cjInputDelegate deleteBackward:deleteBeforeHasText];
    }
}


@end
