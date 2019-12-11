//
//  CJBaseMacro.h
//  Pods
//
//  Created by chenyn on 2019/12/3.
//

#ifndef CJBaseMacro_h
#define CJBaseMacro_h


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

//状态栏高度
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
// 是否是刘海屏
#define ISPROFILEDSCREEN (STATUS_BAR_HEIGHT > 20)
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44

//屏幕顶部工具栏高度
#define TOP_TOOL_BAR_HEIGHT (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)
//屏幕底部工具栏高度
#define BOTTOM_BAR_HEIGHT 50

//iPhoneX 安全区域外底部高度
#define UNSAFE_BOTTOM_HEIGHT 34

#define IsPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH (IsPortrait ? MIN(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)) : MAX(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)))

#define SCREEN_HEIGHT (IsPortrait ? MAX(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)) : MIN(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)))

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

#define cj_empty_array(arr) (arr == nil || arr.count == 0)

#define cj_empty_string(string) (string == nil || string.length == 0)

#define cj_nil_object(obj) (obj == nil || obj == [NSNull null])

/**
 说明：在链接静态库的时候如果使用了category，在编译到静态库时，这些代码模块实际上是存在不同的obj文件里的。程序在连接Category方法时，实际上只加载了Category模块，扩展的基类代码并没有被加载。这样，程序虽然可以编译通过，但是在运行时，因为找不到基类模块，就会出现unrecognized selector 这样的错误。我们可以在Other Linker Flags中添加-all_load、-force_load、-ObjC等flag解决该问题，同时也可以使用如下的宏
 使用：
 NT_SYNTH_DUMMY_CLASS(NSString_NTAdd)
 */
#ifndef NT_SYNTH_DUMMY_CLASS
#define NT_SYNTH_DUMMY_CLASS(_name_) \
@interface NT_SYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation NT_SYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


#endif /* CJBaseMacro_h */
