//
//  NSArray+Cajian.h
//  CJBase
//
//  Created by chenyn on 2019/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Cajian)


/// 数组map遍历方法
/// @param transform 操作block
/// 注：不支持异步操作
- (NSArray*)cj_map:(id(^)(id))transform;


/// 数组filter过滤方法
/// @param includeElement 过滤block
/// 注：不支持异步操作
- (NSArray*)cj_filter:(BOOL(^)(id))includeElement;

@end

NS_ASSUME_NONNULL_END
