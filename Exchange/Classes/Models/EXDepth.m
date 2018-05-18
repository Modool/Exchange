
//
//  EXDepth.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepth.h"

@interface EXDepth ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) BOOL buy;

@property (nonatomic, assign) double price;

@end

@implementation EXDepth

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXDepth *depth;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
               @keypath(depth, symbol): @"symbol",
               @keypath(depth, exchangeDomain): @"exchange_domain",
               @keypath(depth, volume): @"volume",
               @keypath(depth, price): @"price",
               @keypath(depth, buy): @"buy",
               }];
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end

@interface EXDepthSet ()

@property (nonatomic, copy) NSArray<EXDepth *> *asks;

@property (nonatomic, copy) NSArray<EXDepth *> *bids;

@end

@implementation EXDepthSet

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXDepthSet *depthSet;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(depthSet, asks): @"asks",
               @keypath(depthSet, bids): @"bids",
               }];
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;{
    EXDepthSet *depthSet;
    return @{@keypath(depthSet, asks): EXDepth.class,
             @keypath(depthSet, bids): EXDepth.class,};
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;{
    NSMutableDictionary *dictionary = [dic mutableCopy];
    
    NSArray<NSArray<NSNumber *> *> *asks = dictionary[@"asks"];
    NSArray<NSArray<NSNumber *> *> *bids = dictionary[@"bids"];
    
    NSMutableArray<NSDictionary *> *askItems = [NSMutableArray array];
    NSMutableArray<NSDictionary *> *bidItems = [NSMutableArray array];
    
    for (NSArray<NSNumber *> *items in asks) {
        NSDictionary *askItem = @{@"volume": items.lastObject, @"price": items.firstObject, @"buy": @YES};
        [askItems addObject:askItem];
    }
    
    for (NSArray<NSNumber *> *items in bids) {
        NSDictionary *bidItem = @{@"volume": items.lastObject, @"price": items.firstObject, @"buy": @NO};
        [bidItems addObject:bidItem];
    }
    dictionary[@"asks"] = askItems.copy;
    dictionary[@"bids"] = bidItems.copy;
    
    return dictionary.copy;
}

@end
