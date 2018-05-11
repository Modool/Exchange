//
//  EXTrade.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTrade.h"

@interface EXTrade ()

@property (nonatomic, copy) EXTradeTypeString typeString;

@property (nonatomic, assign) double price;
@property (nonatomic, assign) double amount;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXTrade

+ (instancetype)tradeWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time;{
    return [[self alloc] initWithObjectID:objectID price:price amount:amount type:type time:time];
}

- (instancetype)initWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time;{
    if (self = [super init]) {
        self.objectID = objectID;
        _price = price;
        _amount = amount;
        _type = type;
        _time = time;
    }
    return self;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXTrade *trade;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(trade, objectID): @"tid",
              @keypath(trade, price): @"price",
               @keypath(trade, amount): @"amount",
               @keypath(trade, time): @"date_ms",
               @keypath(trade, typeString): @"type",
               }];
}

- (void)setTypeString:(EXTradeTypeString)typeString{
    if (_typeString != typeString) {
        _typeString = typeString;
        
        _type = EXTradeTypeFromString(typeString);
    }
}

- (BOOL)buy{
    return self.type & EXTradeTypeBuy;
}

- (BOOL)market{
    return self.type & EXTradeTypeMarket;
}

@end
