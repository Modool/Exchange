//
//  EXOrder.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOrder.h"

@interface EXOrder ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) EXTradeType type;

@property (nonatomic, assign) double amount;

@property (nonatomic, assign) double dealAmount;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double unitPrice;
@property (nonatomic, assign) double averagePrice;

@property (nonatomic, assign) EXOrderStatus status;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXOrder

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXOrder *order;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(order, objectID): @[@"id", @"objectID", @"order_id", @"orderId"],
               @keypath(order, exchangeDomain): @"exchange_domain",
               @keypath(order, symbol): @"symbol",
               @keypath(order, status): @"status",
               @keypath(order, type): @[@"type", @"tradeType"],
               @keypath(order, amount): @[@"amount", @"tradeAmount"],
               @keypath(order, dealAmount): @[@"deal_amount", @"completedTradeAmount"],
               @keypath(order, price): @[@"price", @"tradePrice"],
               @keypath(order, unitPrice): @[@"unit_price", @"tradeUnitPrice"],
               @keypath(order, averagePrice): @[@"avg_price", @"averagePrice"],
               @keypath(order, time): @[@"create_date", @"createdDate"],
               }];
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic{
    NSMutableDictionary *dictinoary = dic.mutableCopy;
    EXTradeTypeString typeString = dictinoary[@"type"] ?: dictinoary[@"tradeType"];
    
    dictinoary[@"type"] = @(EXTradeTypeFromString(typeString));
    
    return dictinoary;
}

- (BOOL)buy{
    return self.type & EXTradeTypeBuy;
}

- (BOOL)market{
    return self.type & EXTradeTypeMarket;
}

- (void)setSymbol:(NSString *)symbol{
    if (_symbol != symbol) {
        _symbol = symbol;
        
        NSArray *components = [symbol componentsSeparatedByString:@"_"];
        _name = components.firstObject;
        _basic = components.lastObject;
    }
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end
