//
//  EXProductManager+Database.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+Database.h"
#import "EXDatabaseAccessor.h"

#import "EXTicker.h"
#import "EXProduct.h"
#import "EXExchange.h"
#import "EXBalance.h"
#import "EXTrade.h"
#import "EXOrder.h"
#import "EXKLineMetadata.h"

@implementation EXProductManager (Database)

- (EXProduct *)_productByProductID:(NSString *)productID;{
    __block EXProduct *product = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXProduct.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDConditionSet *set = MDDConditionSet1(MDDConditionPrimary1(processor.tableInfo, productID));
        product = [[processor queryWithConditionSet:set] firstObject];
    }];
    return product;
}

- (EXBalance *)_balanceByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    __block EXBalance *balance = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXBalance.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(balance, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(balance, symbol), symbol);
        balance = [[processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)] firstObject];
    }];
    return balance;
}

- (EXTicker *)_tickerByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    __block EXTicker *ticker = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXBalance.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(ticker, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(ticker, symbol), symbol);
        ticker = [[processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)] firstObject];
    }];
    return ticker;
}

- (NSArray<EXProduct *> *)_productsByExchange:(NSString *)domain keyword:(NSString *)keyword range:(NSRange)range;{
    EXProduct *sample;
    
    __block NSArray<EXProduct *> *products = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXProduct.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = domain.length ? MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain) : nil;
        MDDCondition *condition2 = keyword.length ? MDDConditionProperty2(processor.tableInfo, @keypath(sample, symbol), fmts(@"%%%@%%", keyword), MDDOperationLike) : nil;
        MDDConditionSet *set = nil;
        
        if (condition1) set = MDDConditionSet1(condition1);
        if (condition2) {
            if (set) [set and:condition2];
            else set = MDDConditionSet1(condition2);
        }
        products = [processor queryWithConditionSet:set range:range orderByProperty:@keypath(sample, symbol) ascending:YES];
    }];
    return products;
}

- (NSArray<EXProduct *> *)_collectedProductsInRange:(NSRange)range;{
    EXProduct *sample;
    
    __block NSArray<EXProduct *> *products = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXProduct.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(sample, collected), @YES);
        products = [processor queryWithConditionSet:MDDConditionSet1(condition)];
    }];
    return products;
}

- (NSArray<EXProduct *> *)_collectedProductsByExchange:(NSString *)domain range:(NSRange)range;{
    EXProduct *sample;
    
    __block NSArray<EXProduct *> *products = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXProduct.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, collected), @YES);
        products = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)];
    }];
    return products;
}

- (NSArray<EXBalance *> *)_balancesByExchange:(NSString *)domain;{
    EXBalance *balance;
    
    __block NSArray<EXBalance *> *balances = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXBalance.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(balance, exchangeDomain), domain);
        balances = [processor queryWithConditionSet:MDDConditionSet1(condition)];
    }];
    return balances;
}

- (NSArray<EXTicker *> *)_tickersByExchange:(NSString *)domain;{
    EXTicker *ticker;
    
    __block NSArray<EXTicker *> *tickers = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXTicker.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(ticker, exchangeDomain), domain);
        tickers = [processor queryWithConditionSet:MDDConditionSet1(condition)];
    }];
    return tickers;
}

- (NSArray<EXDepth *> *)_depthsByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    EXDepth *sample;
    __block NSArray<EXDepth *> *depths = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXDepth.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), symbol);
        depths = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)];
    }];
    return depths;
}

- (NSArray<EXDepth *> *)_depthsByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;{
    EXDepth *sample;
    __block NSArray<EXDepth *> *depths = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXDepth.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), symbol);
        MDDCondition *condition3 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, buy), @(buy));
        depths = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2, condition3)];
    }];
    return depths;
}

- (NSArray<EXTrade *> *)_tradesByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    EXTrade *sample;
    __block NSArray<EXTrade *> *depths = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXTrade.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), symbol);
        depths = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)];
    }];
    return depths;
}

- (NSArray<EXTrade *> *)_tradesByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;{
    EXTrade *sample;
    __block NSArray<EXTrade *> *trades = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXTrade.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), symbol);
        MDDCondition *condition3 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, buy), @(buy));
        trades = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2, condition3)];
    }];
    return trades;
}

- (NSArray<EXOrder *> *)_ordersByExchange:(NSString *)domain;{
    EXOrder *sample;
    __block NSArray<EXOrder *> *orders = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXOrder.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        orders = [processor queryWithConditionSet:MDDConditionSet1(condition)];
    }];
    return orders;
}

- (NSArray<EXOrder *> *)_ordersByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    EXOrder *sample;
    __block NSArray<EXOrder *> *orders = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXOrder.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        orders = [processor queryWithConditionSet:MDDConditionSet1(condition)];
    }];
    return orders;
}

- (NSArray<EXKLineMetadata *> *)_linesByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    EXKLineMetadata *sample;
    __block NSArray<EXKLineMetadata *> *lines = nil;
    [[EXDatabaseAccessor.database accessorForClass:EXKLineMetadata.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), domain);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), symbol);
        lines = [processor queryWithConditionSet:MDDConditionSet6(condition1, condition2)];
    }];
    return lines;
}

- (BOOL)_exsitOrderByID:(NSString *)orderID;{
    EXOrder *sample;
    __block NSUInteger count = 0;
    [[EXDatabaseAccessor.database accessorForClass:EXOrder.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        count = [processor queryCountWithProperty:@keypath(sample, objectID) value:orderID];
    }];
    return count > 0;
}

#pragma mark - insert

- (BOOL)_insertProductsWithBlock:(EXProduct *(^)(NSUInteger index, BOOL *stop))block block:(void (^)(BOOL state, UInt64 rowID, NSUInteger index, BOOL *stop))resultBlock;{
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXTrade.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor insertWithObjectsWithBlock:block block:resultBlock];
    }];
    return state;
}

- (BOOL)_insertTrade:(EXTrade *)trade;{
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXTrade.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor insertWithObject:trade];
    }];
    return state;
}

- (BOOL)_insertTrades:(NSArray<EXTrade *> *)trades;{
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXTrade.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor insertWithObjects:trades];
    }];
    return state;
}

- (BOOL)_insertKLines:(NSArray<EXKLineMetadata *> *)lines;{
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXKLineMetadata.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor insertWithObjects:lines];
    }];
    return state;
}

- (BOOL)_insertOrder:(EXOrder *)order;{
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXOrder.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor insertWithObject:order];
    }];
    return state;
}

#pragma mark - update

- (BOOL)_updateProductByID:(NSString *)productID collected:(BOOL)collected;{
    EXProduct *sample;
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXProduct.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        state = [processor updateWithPrimaryValue:productID property:@keypath(sample, collected) value:@(collected)];
    }];
    return state;
}

- (BOOL)_updateTicker:(EXTicker *)ticker;{
    EXTicker *sample;
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXTicker.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), ticker.symbol);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), ticker.exchangeDomain);
        
        MDDConditionSet *set = MDDConditionSet6(condition1, condition2);
        BOOL exsit = [processor queryCountWithConditionSet:set] > 0;
        if (exsit) state = [processor updateWithObject:ticker properties:nil ignoredProperties:nil conditionSet:set];
        else state = [processor insertWithObject:ticker];
    }];
    return state;
}

- (BOOL)_updateBalance:(EXBalance *)balance;{
    EXBalance *sample;
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXBalance.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition1 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, symbol), balance.symbol);
        MDDCondition *condition2 = MDDConditionProperty1(processor.tableInfo, @keypath(sample, exchangeDomain), balance.exchangeDomain);
        
        MDDConditionSet *set = MDDConditionSet6(condition1, condition2);
        BOOL exsit = [processor queryCountWithConditionSet:set] > 0;
        if (exsit) state = [processor updateWithObject:balance properties:nil ignoredProperties:nil conditionSet:set];
        else state = [processor insertWithObject:balance];
    }];
    return state;
}

- (BOOL)_updateOrder:(EXOrder *)order;{
    EXOrder *sample;
    __block BOOL state = NO;
    [[EXDatabaseAccessor.database accessorForClass:EXBalance.class] sync:^(id<MDDProcessor, MDDCoreProcessor> processor) {
        MDDCondition *condition = MDDConditionProperty1(processor.tableInfo, @keypath(sample, objectID), order.objectID);
        MDDConditionSet *set = MDDConditionSet1(condition);
        BOOL exsit = [processor queryCountWithConditionSet:set] > 0;
        if (exsit) state = [processor updateWithObject:order properties:nil ignoredProperties:nil conditionSet:set];
        else state = [processor insertWithObject:order];
    }];
    return state;
}


@end
