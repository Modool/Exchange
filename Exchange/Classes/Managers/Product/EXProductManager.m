//
//  EXProductManager.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"
#import "EXProductManager+Private.h"
#import "EXProductManager+Database.h"

#import "EXExchangeManager.h"
#import "EXSocketManager.h"

#import "EXTicker.h"
#import "EXProduct.h"
#import "EXExchange.h"

@implementation EXProductManager
@dynamic delegates;

+ (void)sync:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;{
    [super sync:block];
}

+ (void)async:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;{
    [super async:block];
}

- (double)rateByExchange:(NSString *)domain name:(NSString *)name basic:(NSString *)basic;{
    NSParameterAssert(domain.length && name.length && basic.length);
    __block EXExchange *exchange = nil;
    [EXExchangeManager sync:^(EXDelegatesAccessor<EXExchangeManager> *accessor) {
        exchange = [accessor exchangeByDomain:domain];
    }];
    
    NSString *defaultBasic = @"usdt";
    if (![basic isEqualToString:defaultBasic]) {
        NSString *symbol = fmts(@"%@_%@", basic, defaultBasic);
        EXTicker *ticker = [self _tickerByExchange:domain symbol:symbol];
        if (ticker) {
            return exchange.currentRate * ticker.lastestPrice;
        } else {
            [EXSocketManager async:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
                [accessor addTickerChannelWithSymbol:symbol];
            }];
        }
    } else {
        return exchange.currentRate;
    }
    return 0;
}

- (EXProduct *)productByProductID:(NSString *)productID;{
    NSParameterAssert(productID.length);
    return [self _productByProductID:productID];
}

- (EXBalance *)balanceByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _balanceByExchange:domain symbol:symbol];
}

- (EXTicker *)tickerByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _tickerByExchange:domain symbol:symbol];
}

- (NSArray<EXProduct *> *)products;{
    return [self _productsByExchange:nil keyword:nil range:NSRangeUnset];
}

- (NSArray<EXProduct *> *)productsAtPage:(NSUInteger)page size:(NSUInteger)size;{
    NSUInteger location = (page - 1) * size;
    return [self _productsByExchange:nil keyword:nil range:NSMakeRange(location, size)];
}

- (NSArray<EXProduct *> *)productsWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;{
    NSUInteger location = (page - 1) * size;
    return [self _productsByExchange:nil keyword:nil range:NSMakeRange(location, size)];
}

- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain;{
    NSParameterAssert(domain.length);
    return [self _productsByExchange:domain keyword:nil range:NSRangeUnset];
}

- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain page:(NSUInteger)page size:(NSUInteger)size;{
    NSParameterAssert(domain.length);
    NSUInteger location = (page - 1) * size;
    return [self _productsByExchange:domain keyword:nil range:NSMakeRange(location, size)];
}

- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain keyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;{
    NSParameterAssert(domain.length);
    
    NSUInteger location = (page - 1) * size;
    return [self _productsByExchange:domain keyword:nil range:NSMakeRange(location, size)];
}

- (NSArray<EXProduct *> *)collectedProducts;{
    return [self _collectedProductsInRange:NSRangeUnset];
}

- (NSArray<EXProduct *> *)collectedProductsAtPage:(NSUInteger)page size:(NSUInteger)size;{
    NSUInteger location = (page - 1) * size;
    
    return [self _collectedProductsInRange:NSMakeRange(location, size)];
}

- (NSArray<EXProduct *> *)collectedProductsByExchange:(NSString *)domain;{
    NSParameterAssert(domain.length);
    
    return [self _collectedProductsByExchange:domain range:NSRangeUnset];
}

- (NSArray<EXProduct *> *)collectedProductsByExchange:(NSString *)domain page:(NSUInteger)page size:(NSUInteger)size;{
    NSParameterAssert(domain.length);
    NSUInteger location = (page - 1) * size;
    
    return [self _collectedProductsByExchange:domain range:NSMakeRange(location, size)];
}

- (NSArray<EXBalance *> *)balancesByExchange:(NSString *)domain;{
    NSParameterAssert(domain.length);
    return [self _balancesByExchange:domain];
}

- (NSArray<EXTicker *> *)tickersByExchange:(NSString *)domain;{
    NSParameterAssert(domain.length);
    return [self _tickersByExchange:domain];
}

- (NSArray<EXDepth *> *)depthsByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _depthsByExchange:domain symbol:symbol];
}

- (NSArray<EXDepth *> *)depthsByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _depthsByExchange:domain symbol:symbol buy:buy];
}

- (NSArray<EXTrade *> *)tradesByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _tradesByExchange:domain symbol:symbol];
}

- (NSArray<EXTrade *> *)tradesByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _tradesByExchange:domain symbol:symbol buy:buy];
}

- (NSArray<EXOrder *> *)ordersByExchange:(NSString *)domain;{
    NSParameterAssert(domain.length);
    return [self _ordersByExchange:domain];
}

- (NSArray<EXOrder *> *)ordersByExchange:(NSString *)domain symbol:(NSString *)symbol;{
    NSParameterAssert(domain.length && symbol.length);
    return [self _ordersByExchange:domain symbol:symbol];
}

- (BOOL)exsitOrderByID:(NSString *)orderID {
    NSParameterAssert(orderID.length);
    return [self _exsitOrderByID:orderID];
}

#pragma mark - insert

- (BOOL)insertTrade:(EXTrade *)trade;{
    NSParameterAssert(trade);
    BOOL state = [self _insertTrade:trade];
    if (state) {
        [self _respondDelegateForAppendedTrade:trade];
    }
    return state;
}

- (BOOL)insertTrades:(NSArray<EXTrade *> *)trades forProductByID:(NSString *)productID;{
    NSParameterAssert(trades.count && productID.length);
    if (trades.count == 1) return [self insertTrade:trades.firstObject];
    
    BOOL state = [self _insertTrades:trades];
    if (state) {
        [self _respondDelegateForAppendedTrades:trades forProductID:productID];
    }
    return state;
}

- (BOOL)insertKLines:(NSArray<EXKLineMetadata *> *)lines forProductByID:(NSString *)productID;{
    NSParameterAssert(lines.count && productID.length);
    BOOL state = [self _insertKLines:lines];
    if (state) {
        [self _respondDelegateForAppendedKLines:lines forProductID:productID];
    }
    return state;
}

- (BOOL)insertOrder:(EXOrder *)order;{
    NSParameterAssert(order);
    BOOL state = [self _insertOrder:order];
    if (state) {
        [self _respondDelegateForAppendedOrder:order];
    }
    return state;
}

#pragma mark - update

- (BOOL)updateProductByID:(NSString *)productID collected:(BOOL)collected;{
    NSParameterAssert(productID.length);
    return [self _updateProductByID:productID collected:collected];
}

- (BOOL)updateTicker:(EXTicker *)ticker;{
    NSParameterAssert(ticker);
    BOOL state = [self _updateTicker:ticker];
    if (state) {
        [self _respondDelegateForUpdatedTicker:ticker];
    }
    return state;
}

- (BOOL)updateBalance:(EXBalance *)balance;{
    NSParameterAssert(balance);
    BOOL state = [self _updateBalance:balance];
    if (state) {
        [self _respondDelegateForUpdatedBalance:balance];
    }
    return state;
}

- (BOOL)updateOrder:(EXOrder *)order;{
    NSParameterAssert(order);
    BOOL state = [self _updateOrder:order];
    if (state) {
        [self _respondDelegateForUpdatedOrder:order];
    }
    return state;
}

#pragma mark - delegate

- (void)addDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forProductID:(NSString *)productID;{
    NSParameterAssertReturnVoid(productID.length);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _nonNullDelegatesByProductID:productID];
    [delegates addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forProductID:(NSString *)productID;{
    NSParameterAssertReturnVoid(productID.length);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _nonNullDelegatesByProductID:productID];
    if (delegateQueue) {
        [delegates removeDelegate:delegate delegateQueue:delegateQueue];
    } else {
        [delegates removeDelegate:delegate];
    }
    if (!delegates.count) {
        [self.symbolDelegates removeObjectForKey:productID];
    }
}

- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate forProductID:(NSString *)productID;{
    [self removeDelegate:delegate delegateQueue:nil forProductID:productID];
}

- (void)removeDelegatesByProductID:(NSString *)productID;{
    [self.symbolDelegates removeObjectForKey:productID];
}

@end
