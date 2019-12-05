//
//  CJShareModel.m
//  CJBase
//
//  Created by chenyn on 2019/12/4.
//

#import "CJShareModel.h"
#import "HttpHelper.h"
#import <NIMKit.h>
#import <coobjc/coobjc.h>

@interface CJShareModel ()

@property (nonatomic, assign) NSInteger myType;

@end

@implementation CJShareModel


- (CajianShareType)type
{
    return _myType;
}

- (COPromise *)share:(NIMSession *)session
{
    COPromise *p = [COPromise promise];
    
//    NSInteger type = self.type;
//    NSString *key = self.appKey;
//    NSString *from = [[NIMSDK sharedSDK].loginManager currentAccount];
//
//    NSString *title;
//    NSString *content;
//    NSString *url;
//
//    if([self isKindOfClass:CJShareImageModel.class]) {
//
//    }
//
//    BaseModel *model = await([HttpHelper post:@"https://centerapi.youxi2018.cn/client/app/show"
//                    params:@{
//                        @"type": [NSString stringWithFormat:@"%ld", (long)type],
//                        @"app_key": key?:@"",
//                        @"from_accid": from?:@"",
//                        @"to": session.sessionId?:@"",
//                        @"title": title?:@"",
//                        @"content": content?:@"",
//                        @"web_url": url?:@"",
//                        @"image_data": image?:@"",
//                        @"extention": extention?:@""
//                    }]);
//
//    if(co_getError()) {
//        [p reject:co_getError()];
//    }else {
//        [p fulfill:model];
//    }
    
    return p;
}

@end

@implementation CJShareTextModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myType = CajianShareTypeText;
    }
    return self;
}

@end

@implementation CJShareImageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myType = CajianShareTypeImage;
    }
    return self;
}

@end
