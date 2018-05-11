//
//  EXProductManager.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"
#import "EXProductManager+Private.h"
#import "EXProductManager+EXSelectedProduct.h"

#import "EXSocketManager.h"
#import "EXExchangeManager.h"
#import "EXHTTPClient.h"

#import "EXExchange.h"
#import "EXTicker.h"

@implementation EXProductManager
@dynamic delegates;

+ (void)sync:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;{
    [super sync:block];
}

+ (void)async:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;{
    [super async:block];
}

- (NSArray<NSString *> *)allSymbols;{
    if (!_allSymbols) {
        _allSymbols = [self.products.allKeys sortedArrayUsingSelector:@selector(compare:)];
    }
    return _allSymbols;
}

- (NSArray<EXProduct *> *)allProducts;{
    if (!_allProducts) {
        _allProducts = [self.products.allValues sortedArrayUsingSelector:@selector(compare:)];
    }
    return _allProducts;
}

- (NSArray<EXProduct *> *)productsAtPage:(NSUInteger)page size:(NSUInteger)size;{
    NSArray<EXProduct *> *products = self.allProducts;
    NSUInteger location = (page - 1) * size;
    if (location > products.count) return nil;
    
    NSUInteger count = MIN(products.count - location, size);
    
    return [products subarrayWithRange:NSMakeRange(location, count)];
}

- (NSArray<EXProduct *> *)productsWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;{
    if (![keyword length]) return [self productsAtPage:page size:size];
    
    NSArray<EXProduct *> *products = [[self.allProducts.rac_sequence filter:^BOOL(EXProduct *product) {
        return [[product symbol] containsString:[keyword lowercaseString]];
    }] array];
    
    NSUInteger location = (page - 1) * size;
    if (location > products.count) return nil;
    
    NSUInteger count = MIN(products.count - location, size);
    
    return [products subarrayWithRange:NSMakeRange(location, count)];
}

- (double)rateFromSymbol:(NSString *)fromSymbol toSymbol:(NSString *)toSymbol exchange:(EXExchange *)exchange;{
    NSString *basicSymbol = @"usdt";
    if (![toSymbol isEqualToString:basicSymbol]) {
        NSString *symbol = fmts(@"%@_%@", toSymbol, basicSymbol);
        EXProduct *product = [self productBySymbol:symbol];
        if (product.ticker) {
            return exchange.currentRate * product.ticker.lastestPrice;
        } else {
            [EXSocketManager async:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
                [accessor addTickerChannelWithSymbol:product.symbol];
            }];
        }
    } else {
        return exchange.currentRate;
    }
    return 0;
}

- (EXProduct *)productBySymbol:(NSString *)symbol;{
    return self.products[symbol];
}

- (NSArray<EXProduct *> *)collectedProducts{
    return [self.products objectsForKeys:self.collectedSymbols notFoundMarker:[[EXProduct alloc] init]];
}

- (NSArray<EXProduct *> *)collectedProductsAtPage:(NSUInteger)page size:(NSUInteger)size;{
    NSArray<NSString *> *symbols = self.collectedSymbols;
    NSUInteger location = (page - 1) * size;
    if (location > symbols.count) return nil;
    
    NSUInteger count = MIN(symbols.count - location, size);
    symbols = [symbols subarrayWithRange:NSMakeRange(location, count)];
    
    return [self.products objectsForKeys:symbols notFoundMarker:[[EXProduct alloc] init]];
}

- (BOOL)isCollectedProductForSymbol:(NSString *)symbol;{
    return [self.collectedSymbols.copy containsObject:symbol];
}

- (BOOL)collectProductWithSymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    
    [self.collectedSymbols addObject:symbol];
    
    [self _saveCollectedProduct];
    [self _respondDelegateForCollectedSymbol:symbol];
    
    return YES;
}

- (BOOL)descollectProductWithSymbol:(NSString *)symbol;{
    if (![self.collectedSymbols containsObject:symbol]) return NO;
    
    [self.collectedSymbols removeObject:symbol];
    
    [self _saveCollectedProduct];
    [self _respondDelegateForDescollectedSymbol:symbol];
    
    return YES;
}

- (EXDepth *)depthBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    return self.depths[symbol];
}

- (EXTicker *)tickerBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    return self.tickers[symbol];
}

- (NSArray<EXTrade *> *)tradesBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    return self.trades[symbol];
}

- (NSArray<EXKLineMetadata *> *)linesBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    return self.lines[symbol];
}

- (NSArray<EXOrder *> *)allOrders;{
    return self.mutableOrders.allValues;
}

- (NSArray<EXOrder *> *)ordersBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    NSDictionary<NSString *, EXOrder *> *orders = self.orders[symbol];
    return orders.allValues;
}

- (NSArray<EXBalance *> *)balances;{
    return self.mutableBalances.allValues;
}

- (EXBalance *)balanceBySymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    return self.mutableBalances[symbol];
}

- (NSMutableDictionary<NSString *, EXBalance *> *)mutableBalances{
    if (!_mutableBalances) {
        _mutableBalances = [NSMutableDictionary dictionaryWithDictionary:[self _synchronizeRemoteBalances]];
    }
    return _mutableBalances;
}

- (void)addDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forSymbol:(NSString *)symbol;{
    NSParameterAssertReturnVoid(symbol.length);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _nonNullDelegatesForSymbol:symbol];
    [delegates addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forSymbol:(NSString *)symbol;{
    NSParameterAssertReturnVoid(symbol.length);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _nonNullDelegatesForSymbol:symbol];
    if (delegateQueue) {
        [delegates removeDelegate:delegate delegateQueue:delegateQueue];
    } else {
        [delegates removeDelegate:delegate];
    }
    if (!delegates.count) {
        [self.symbolDelegates removeObjectForKey:symbol];
    }
}

- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate forSymbol:(NSString *)symbol;{
    [self removeDelegate:delegate delegateQueue:nil forSymbol:symbol];
}

- (void)removeDelegatesForSymbol:(NSString *)symbol;{
    [self.symbolDelegates removeObjectForKey:symbol];
}

#pragma mark - private

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_nonNullDelegatesForSymbol:(NSString *)symbol;{
    NSParameterAssertReturnNil([symbol length]);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol] ?: [MDMulticastDelegate<EXProductManagerSymbolDelegate> new];
    self.symbolDelegates[symbol] = delegates;
    
    return delegates;
}

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_delegatesForSymbol:(NSString *)symbol;{
    NSParameterAssertReturnNil([symbol length]);
    
    return self.symbolDelegates[symbol];
}

- (NSDictionary<NSString *, EXBalance *> *)_synchronizeRemoteBalances{
    __block EXExchange *exchange = nil;
    [EXExchangeManager sync:^(EXDelegatesAccessor<EXExchangeManager> *accessor) {
        exchange = [accessor exchangeByDomain:EXExchangeOKExDomain];
    }];
    
    id<EXHTTPClient> client = exchange.client;
    __block NSDictionary *dictionary = nil;
    __block NSError *remoteError = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    RACDisposable *dsiposable = [[client fetchBalancesSignal] subscribeNext:^(NSDictionary *result) {
        dictionary = result;
    } error:^(NSError *error) {
        remoteError = error;
    } completed:^{
        dispatch_semaphore_signal(semaphore);
    }];
    long state = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (10 * NSEC_PER_SEC)));
    
    [dsiposable dispose];
    if (state || remoteError) return nil;
    
    NSDictionary *freeFunds = dictionary[@"free"];
    NSDictionary *freezedFunds = dictionary[@"freezed"];
    NSMutableDictionary<NSString *, EXBalance *> *balances = [NSMutableDictionary dictionary];
    
    NSMutableSet<EXChannelString> *channels = [NSMutableSet set];
    for (NSString *symbol in freeFunds.allKeys) {
        double free = [freeFunds[symbol] doubleValue];
        
        EXBalance *balance = [[EXBalance alloc] init];
        balance.symbol = symbol;
        balance.free = free;
        
        balances[symbol] = balance;
        
        if (free > 0) [channels addObject:fmts(EXChannelStringBalance, symbol)];
    }
    
    for (NSString *symbol in freezedFunds.allKeys) {
        double freezed = [freezedFunds[symbol] doubleValue];
        EXBalance *balance = balances[symbol];
        if (!balance) {
            balance = [[EXBalance alloc] init];
            balances[symbol] = balance;
        }
        balance.freezed = freezed;
        if (freezed > 0) [channels addObject:fmts(EXChannelStringBalance, symbol)];
    }
    
    return balances.copy;
}

@end
