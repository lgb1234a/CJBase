
#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "HttpConstant.h"
#import "HttpHelper.h"
#import "NSDictionary+Cajian.h"
#import "NSString+Cajian.h"
#import "UIViewController+HUD.h"
#import "XTSafeCollection.h"
#import "UIColor+YYAdd.h"
#import "UIView+CJXib.h"
#import "cokit.h"
#import "coobjc.h"


static NSString *CJUpdateMessageNotification = @"CJUpdateMessageNotification";

#define Notification_Font_Size   11   // 通知文字大小

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/**
 主红色
 */
#define Main_redColor RGBACOLOR(216, 78, 67, 1)

/**
 主背景色
 */
#define Main_BackgColor RGBACOLOR(236, 236, 236, 1)

/**
 主字体偏黑
 */
#define Main_TextGrayColor RGBACOLOR(166, 166, 166, 1)

/**
 主字体主黑
 */
#define Main_TextBlackColor RGBACOLOR(26, 26, 26, 1)

/**
 导航背景色
 */
#define Main_NaviColor RGBACOLOR(236, 236, 236, 1)

/**
 主线设置
 */
#define Main_lineColor RGBACOLOR(227, 226, 229, 1)

#ifdef DEBUG

#define ZZLog(...) NSLog(__VA_ARGS__)

#else

#define ZZLog(...)

#endif

#define CJ_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


/* weak reference */
#define CJ_WEAK_SELF(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define CJ_STRONG_SELF(strongSelf) __strong __typeof(&*weakSelf) strongSelf = weakSelf;
