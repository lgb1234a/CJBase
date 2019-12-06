//
//  NSArray+Cajian.m
//  CJBase
//
//  Created by chenyn on 2019/12/6.
//

#import "NSArray+Cajian.h"

@implementation NSArray (Cajian)

- (NSArray*)cj_map:(id(^)(id))transform {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:transform(obj)];
    }];
    return array;
    
}

- (NSArray*)cj_filter:(BOOL(^)(id))includeElement {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (includeElement(obj)) {
            [array addObject:obj];
        }
    }];
    
    return array;
}

@end
