

//
//  EXOKExHTTPClient+EXTrade.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXTrade.h"
#import "EXTrade.h"

@implementation EXOKExHTTPClient (EXTrade)

- (RACSignal *)fetchTradesWithSymbol:(NSString *)symbol since:(NSTimeInterval)since;{
    return [self GET:@"/api/v1/trades.do" parameters:@{@"symbol": ntoe(symbol), @"since": @(since)} resultClass:[EXTrade class] keyPath:nil];
}

- (RACSignal *)tradeWithSymbol:(NSString *)symbol type:(EXTradeType)type price:(double)price amount:(double)amount;{
    NSString *typeString = EXTradeTypeStringFromType(type);
    
    NSDictionary *parameters = @{@"symbol": ntoe(symbol),
                                   @"type": ntoe(typeString),
                                   @"price": @(price),
                                   @"amount": @(amount)};
    
    return [self POST:@"/api/v1/trade.do" parameters:parameters resultClass:[NSString class] keyPath:@"order_id"];
}

- (RACSignal *)batchTradeWithSymbol:(NSString *)symbol block:(void (^)(EXTradeType *type, double *price, double *amount, BOOL *stop))block;{
    NSMutableArray *orders = [NSMutableArray array];
    BOOL stop = NO;
    while (!stop) {
        EXTradeType type;
        double price;
        double amount;
        
        block(&type, &price, &amount, &stop);
        
        NSString *typeString = EXTradeTypeStringFromType(type);
        NSDictionary *order = @{@"type": ntoe(typeString), @"price": @(price), @"amount": @(amount)};
        [orders addObject:order];
    }
    
    NSDictionary *parameters = @{@"symbol": ntoe(symbol), @"orders_data": orders};
    
    return [self POST:@"/api/v1/batch_trade.do" parameters:parameters resultClass:[NSArray class] keyPath:@"order_info"];
}


@end
