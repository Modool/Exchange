//
//  EXProductManager+Private.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+Private.h"

#import "EXSocketManager.h"
#import "EXExchangeManager.h"
#import "EXHTTPClient.h"

#import "EXBalance+Private.h"

#import "EXExchange.h"
#import "EXTicker.h"
#import "EXProduct.h"
#import "EXOrder.h"
#import "EXTrade.h"

@implementation EXProductManager (Private)

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_nonNullDelegatesByProductID:(NSString *)productID;{
    NSParameterAssertReturnNil([productID length]);
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:productID] ?: [MDMulticastDelegate<EXProductManagerSymbolDelegate> new];
    self.symbolDelegates[productID] = delegates;
    
    return delegates;
}

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_delegatesByProductID:(NSString *)productID;{
    NSParameterAssertReturnNil([productID length]);
    
    return self.symbolDelegates[productID];
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

- (void)_respondDelegateForUpdatedProduct:(EXProduct *)product collected:(BOOL)collected;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateProduct:collected:)]) {
        [[self delegates] productManager:self didUpdateProduct:product collected:collected];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:product.objectID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didUpdateProduct:collected:)]) {
        [delegates productManager:self productID:product.objectID didUpdateProduct:product collected:collected];
    }
}

- (void)_respondDelegateForUpdatedTicker:(EXTicker *)ticker;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateTicker:)]) {
        [[self delegates] productManager:self didUpdateTicker:ticker];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:ticker.productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didUpdateTicker:)]) {
        [delegates productManager:self productID:ticker.productID didUpdateTicker:ticker];
    }
}

- (void)_respondDelegateForUpdatedBalance:(EXBalance *)balance;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateBalance:)]) {
        [[self delegates] productManager:self didUpdateBalance:balance];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:balance.productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didUpdateBalance:)]) {
        [delegates productManager:self productID:balance.productID didUpdateBalance:balance];
    }
}

- (void)_respondDelegateForAppendedOrder:(EXOrder *)order;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didAppendOrder:)]) {
        [[self delegates] productManager:self didAppendOrder:order];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:order.productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didAppendOrder:)]) {
        [delegates productManager:self productID:order.productID didAppendOrder:order];
    }
}

- (void)_respondDelegateForUpdatedOrder:(EXOrder *)order;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateOrder:)]) {
        [[self delegates] productManager:self didUpdateOrder:order];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:order.productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didUpdateOrder:)]) {
        [delegates productManager:self productID:order.productID didUpdateOrder:order];
    }
}

- (void)_respondDelegateForAppendedTrade:(EXTrade *)trade;{
    [self _respondDelegateForAppendedTrades:@[trade] forProductID:trade.productID];
}

- (void)_respondDelegateForAppendedTrades:(NSArray<EXTrade *> *)trades forProductID:(NSString *)productID;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didAppendTrades:forProductID:)]) {
        [[self delegates] productManager:self didAppendTrades:trades forProductID:productID];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didAppendTrades:)]) {
        [delegates productManager:self productID:productID didAppendTrades:trades];
    }
}

- (void)_respondDelegateForUpdatedDepthSet:(EXDepthSet *)depthSet forProductID:(NSString *)productID;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateDepthSet:forProductID:)]) {
        [[self delegates] productManager:self didUpdateDepthSet:depthSet forProductID:productID];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didUpdateDepthSet:)]) {
        [delegates productManager:self productID:productID didUpdateDepthSet:depthSet];
    }
}

- (void)_respondDelegateForAppendedKLines:(NSArray<EXKLineMetadata *> *)lines forProductID:(NSString *)productID;{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:didAppendKLines:forProductID:)]) {
        [[self delegates] productManager:self didAppendKLines:lines forProductID:productID];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesByProductID:productID];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:productID:didAppendKLines:)]) {
        [delegates productManager:self productID:productID didAppendKLines:lines];
    }
}

@end
