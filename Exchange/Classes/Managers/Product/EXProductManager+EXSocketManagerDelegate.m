//
//  EXProductManager+EXSocketManagerDelegate.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+EXSocketManagerDelegate.h"
#import "EXProductManager+Private.h"

#import "EXProduct+Private.h"
#import "EXTicker.h"
#import "EXDepth.h"
#import "EXTrade.h"
#import "EXOrder.h"
#import "EXBalance.h"
#import "EXKLineMetadata.h"

@implementation EXProductManager (EXSocketManagerDelegatePrivate)

- (void)_handleMessage:(id)message forChannel:(EXChannelString)channel{
    if ([channel containsString:@"ticker"]) {
        [self _matchTickerWithMessage:message forChannel:channel];
    } else if ([channel containsString:@"depth"]) {
        [self _matchDepthWithMessage:message forChannel:channel];
    } else if ([channel containsString:@"deals"]) {
        [self _matchTradeWithMessage:message forChannel:channel];
    } else if ([channel containsString:@"kline"]) {
        [self _matchKLineWithMessage:message forChannel:channel];
    } else if ([channel containsString:@"balance"]) {
        [self _matchBalanceWithMessage:message forChannel:channel];
    } else if ([channel containsString:@"order"]) {
        [self _matchOrderWithMessage:message forChannel:channel];
    }
}

- (void)_matchTickerWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXTicker *ticker = [message modelOfClass:[EXTicker class] error:&error];
    if (error) return;
    
    [self _handleTicker:ticker forSymbol:symbol];
}

- (void)_matchDepthWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXDepth *depth = [message modelOfClass:[EXDepth class] error:&error];
    if (error) return;
    
    [self _handleDepth:depth forSymbol:symbol];
}

- (void)_matchTradeWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSMutableArray *trades = [NSMutableArray array];
    for (NSArray *infos in message) {
        NSString *objectID = [infos firstObject];
        double price = [infos.count > 1 ? infos[1] : nil doubleValue];
        double amount = [infos.count > 2 ? infos[2] : nil doubleValue];
        NSTimeInterval time = [infos.count > 3 ? infos[3] : nil doubleValue];
        EXTradeType type = EXTradeTypeFromString(infos.count > 4 ? infos[4] : nil);;
        EXTrade *trade = [EXTrade tradeWithObjectID:objectID price:price amount:amount type:type time:time];
        [trades addObject:trade];
    }
    [self _handleTrades:trades forSymbol:symbol];
}

- (void)_matchKLineWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSMutableArray *lines = [NSMutableArray array];
    for (NSArray *infos in message) {
        NSTimeInterval time = [[infos firstObject] doubleValue];
        double open = [infos.count > 1 ? infos[1] : nil doubleValue];
        double highest = [infos.count > 2 ? infos[2] : nil doubleValue];
        double lowest = [infos.count > 3 ? infos[3] : nil doubleValue];
        double close = [infos.count > 4 ? infos[4] : nil doubleValue];
        double volume = [infos.count > 5 ? infos[5] : nil doubleValue];
        
        EXKLineMetadata *line = [EXKLineMetadata dataWithOpen:open close:close highest:highest lowest:lowest volume:volume time:time];
        [lines addObject:line];
    }
    [self _handleKLines:lines forSymbol:symbol];
}

- (void)_matchBalanceWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXBalance *balance = [message modelOfClass:[EXBalance class] error:&error];
    if (error) return;
    
    [self _handleBalance:balance forSymbol:symbol];
}

- (void)_matchOrderWithMessage:(id)message forChannel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXOrder *order = [message modelOfClass:[EXOrder class] error:&error];
    if (error) return;
    
    [self _handleOrder:order forSymbol:symbol];
}

- (void)_handleTicker:(EXTicker *)ticker forSymbol:(NSString *)symbol{
    EXProduct *product = [self productBySymbol:symbol];
    product.ticker = ticker;
    
    self.products[symbol] = product;
    self.tickers[symbol] = ticker;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didUpdateTicker:)]) {
        [[self delegates] productManager:self symbol:symbol didUpdateTicker:ticker];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateTicker:forSymbol:)]) {
        [delegates productManager:self didUpdateTicker:ticker forSymbol:symbol];
    }
}

- (void)_handleDepth:(EXDepth *)depth forSymbol:(NSString *)symbol{
    EXProduct *product = [self productBySymbol:symbol];
    product.depth = depth;
    self.products[symbol] = product;
    self.depths[symbol] = depth;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didAppendDepth:)]) {
        [[self delegates] productManager:self symbol:symbol didAppendDepth:depth];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didAppendDepth:forSymbol:)]) {
        [delegates productManager:self didAppendDepth:depth forSymbol:symbol];
    }
}

- (void)_handleBalance:(EXBalance *)balance forSymbol:(NSString *)symbol{
    self.mutableBalances[symbol] = balance;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didUpdateBalance:)]) {
        [[self delegates] productManager:self symbol:symbol didUpdateBalance:balance];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateBalance:forSymbol:)]) {
        [delegates productManager:self didUpdateBalance:balance forSymbol:symbol];
    }
}

- (void)_handleTrades:(NSArray<EXTrade *> *)trades forSymbol:(NSString *)symbol{
    NSArray *localTrades = self.trades[symbol] ?: @[];
    localTrades = [localTrades arrayByAddingObjectsFromArray:trades];
    
    EXProduct *product = [self productBySymbol:symbol];
    product.trades = localTrades;
    self.products[symbol] = product;
    self.trades[symbol] = localTrades;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didAppendTrades:)]) {
        [[self delegates] productManager:self symbol:symbol didAppendTrades:trades];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didAppendTrades:forSymbol:)]) {
        [delegates productManager:self didAppendTrades:trades forSymbol:symbol];
    }
}

- (void)_handleKLines:(NSArray<EXKLineMetadata *> *)lines forSymbol:(NSString *)symbol{
    NSArray *localLines = self.lines[symbol] ?: @[];
    localLines = [localLines arrayByAddingObjectsFromArray:lines];
    
    EXProduct *product = [self productBySymbol:symbol];
    product.lines = localLines;
    self.products[symbol] = product;
    self.lines[symbol] = localLines;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didAppendKLines:)]) {
        [[self delegates] productManager:self symbol:symbol didAppendKLines:lines];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didAppendKLines:forSymbol:)]) {
        [delegates productManager:self didAppendKLines:lines forSymbol:symbol];
    }
}

- (void)_handleOrder:(EXOrder *)order forSymbol:(NSString *)symbol{
    NSMutableDictionary<NSString *, EXOrder *> *eachOrders = self.orders[symbol] ?: [NSMutableDictionary dictionary];
    eachOrders[order.objectID] = order;
    self.orders[symbol] = eachOrders;
    self.mutableOrders[order.objectID] = order;
    
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didUpdateOrder:)]) {
        [[self delegates] productManager:self symbol:symbol didUpdateOrder:order];
    }
    
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didUpdateOrder:forSymbol:)]) {
        [delegates productManager:self didUpdateOrder:order forSymbol:symbol];
    }
}

@end

@implementation EXProductManager (EXSocketManagerDelegate)

- (void)didLoginServerWithSocketManager:(EXSocketManager *)socketManager{
    
}

- (void)socketManager:(EXSocketManager *)socketManager channel:(EXChannelString)channel didReceiveMessage:(id)message;{
    [self _handleMessage:message forChannel:channel];
}

@end
