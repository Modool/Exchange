//
//  EXTrade.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTrade.h"

@interface EXTrade ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) EXTradeType type;

@property (nonatomic, assign) double price;
@property (nonatomic, assign) double amount;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXTrade

+ (instancetype)tradeWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time symbol:(NSString *)symbol domain:(NSString *)domain;{
    return [[self alloc] initWithObjectID:objectID price:price amount:amount type:type time:time symbol:symbol domain:domain];
}

- (instancetype)initWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time symbol:(NSString *)symbol domain:(NSString *)domain;{
    if (self = [super init]) {
        self.objectID = objectID;
        _price = price;
        _amount = amount;
        _type = type;
        _time = time;
        _symbol = symbol;
        _exchangeDomain = domain;
    }
    return self;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXTrade *trade;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(trade, objectID): @[@"id", @"tid"],
               @keypath(trade, exchangeDomain): @"exchange_domain",
               @keypath(trade, symbol): @"symbol",
               @keypath(trade, price): @"price",
               @keypath(trade, amount): @"amount",
               @keypath(trade, time): @"date_ms",
               @keypath(trade, type): @"type",
               }];
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic{
    NSMutableDictionary *dictinoary = dic.mutableCopy;
    EXTradeTypeString typeString = dictinoary[@"type"];
    
    dictinoary[@"type"] = @(EXTradeTypeFromString(typeString));
    
    return dictinoary;
}

- (BOOL)buy{
    return self.type & EXTradeTypeBuy;
}

- (BOOL)market{
    return self.type & EXTradeTypeMarket;
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end
