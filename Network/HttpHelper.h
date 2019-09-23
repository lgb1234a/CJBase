//
//  HttpHelper.h
//  CaJian
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import <coobjc/coobjc.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *CJ_net_err_msg = @"网络开小差了～";

@interface HttpHelper : NSObject

/**
 使用协程的方式发起post请求

 @param url 请求url
 @param params 参数
 @return 返回promise
 */
+ (COPromise *)post:(NSString *)url params:(NSDictionary *)params;


/**
 使用协程的方式发起post请求

 @param url 请求url
 @param params 参数
 @return 返回promise
 */
+ (COPromise *)get:(NSString *)url
            params:(NSDictionary *)params;


/**
 使用协程的方式上传文件

 @param url 请求路径
 @param params 请求参数
 @param path 请求文件路径
 @return 返回promise
 */
+ (COPromise *)upload:(NSString *)url
               params:(NSDictionary *)params
                 path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
