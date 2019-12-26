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
#import "NSData+NTAdd.h"
#import <Flutter/Flutter.h>

@interface CJShareModel ()

@property (nonatomic, assign) NSInteger myType;

@end

@implementation CJShareModel

- (instancetype)initWithData:(NSDictionary *)shareData
{
    self = [super init];
    if(self) {
        NSInteger type = [shareData[@"type"] integerValue];
        
        if(type == CajianShareTypeText) {
            return [[CJShareTextModel alloc] initWithData:shareData];
        }else if(type == CajianShareTypeImage) {
            return [[CJShareImageModel alloc] initWithData:shareData];
        }else if(type == CajianShareTypeBusinessCard) {
            return [[CJShareBusinessCardModel alloc] initWithData:shareData];
        }
    }
    return self;
}

- (CajianShareType)type
{
    return _myType;
}

- (COPromise *)shareTo:(NIMSession *)session
{
    COPromise *p = [COPromise promise];
    
    NSInteger type = self.type;
    NSString *key = self.appKey;
    NSString *from = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    NSMutableDictionary *params = @{@"type": [NSString stringWithFormat:@"%ld", (long)type],
        @"app_key": key?:@"0",
        @"from_accid": from?:@"",
        @"to": session.sessionId?:@""}.mutableCopy;
    
    if([self isKindOfClass:CJShareTextModel.class]) {
        CJShareTextModel *textModel = (CJShareTextModel *)self;
        [params setObject:textModel.text?:@"" forKey:@"content"];
    }
    else if([self isKindOfClass:CJShareImageModel.class]) {
        // 图片
        CJShareImageModel *imgModel = (CJShareImageModel *)self;
        
        NSString *imgString = imgModel.imageUrl;
        if(imgModel.imageData != nil) {
            
            imgString = [imgModel.imageData base64EncodedString];
        }
        [params setObject:imgString?:@"" forKey:@"image_data"];
    }else
    {
    }

    BaseModel *model = await([HttpHelper post:@"https://centerapi.youxi2018.cn/client/app/show"
                    params:params]);

    if(co_getError()) {
        [p reject:co_getError()];
    }else {
        [p fulfill:model];
    }
    
    return p;
}

@end

@implementation CJShareTextModel

- (instancetype)initWithData:(NSDictionary *)shareData
{
    self = [super init];
    if (self) {
        self.myType = CajianShareTypeText;
        
        self.text = shareData[@"text"];
    }
    return self;
}

@end

@implementation CJShareImageModel

- (instancetype)initWithData:(NSDictionary *)shareData
{
    self = [super init];
    if (self) {
        self.myType = CajianShareTypeImage;
        
        FlutterStandardTypedData *imgData = shareData[@"imgData"];
        self.imageData = imgData.data;
    }
    return self;
}

@end


@implementation CJShareBusinessCardModel

- (instancetype)initWithData:(NSDictionary *)shareData
{
    self = [super init];
    if (self) {
        self.myType = CajianShareTypeBusinessCard;
        
        self.accid = shareData[@"accid"];
        self.nickName = shareData[@"nickName"];
        self.imageUrl = shareData[@"imageUrl"];
    }
    return self;
}

@end
