
//
//  EXDepth.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepth.h"

@implementation EXDepthItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXDepthItem *depthItem;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(depthItem, volume): @"volume",
               @keypath(depthItem, price): @"price",
               }];
}

@end

@implementation EXDepth

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXDepth *depth;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(depth, asks): @"asks",
               @keypath(depth, bids): @"bids",
               }];
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;{
    NSMutableDictionary *dictionary = [dic mutableCopy];
    
    NSArray<NSArray<NSNumber *> *> *asks = dictionary[@"asks"];
    NSArray<NSArray<NSNumber *> *> *bids = dictionary[@"bids"];
    
    NSMutableArray<NSDictionary *> *askItems = [NSMutableArray array];
    NSMutableArray<NSDictionary *> *bidItems = [NSMutableArray array];
    
    for (NSArray<NSNumber *> *items in asks) {
        NSDictionary *askItem = @{@"volume": items.firstObject, @"price": items.lastObject};
        [askItems addObject:askItem];
    }
    
    for (NSArray<NSNumber *> *items in bids) {
        NSDictionary *bidItem = @{@"volume": items.firstObject, @"price": items.lastObject};
        [bidItems addObject:bidItem];
    }
    dictionary[@"asks"] = asks;
    dictionary[@"bids"] = bids;
    
    return dictionary.copy;
}

@end
