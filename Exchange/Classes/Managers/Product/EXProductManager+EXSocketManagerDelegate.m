
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
#import "EXTicker+Private.h"
#import "EXBalance+Private.h"

#import "EXDepth.h"
#import "EXTrade.h"
#import "EXTradeSet.h"
#import "EXOrder.h"
#import "EXKLineMetadata.h"
#import "EXExchange.h"

@implementation EXProductManager (EXSocketManagerDelegatePrivate)

- (void)_handleMessage:(id)message exchange:(EXExchange *)exchange channel:(EXChannelString)channel{
    
    [self _handleMessage:message domain:exchange.domain channel:channel];
}

- (void)_handleMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
    if ([channel containsString:@"ticker"]) {
        [self _matchTickerWithMessage:message domain:domain channel:channel];
    } else if ([channel containsString:@"depth"]) {
        [self _matchDepthWithMessage:message domain:domain channel:channel];
    } else if ([channel containsString:@"deals"]) {
        [self _matchTradeWithMessage:message domain:domain channel:channel];
    } else if ([channel containsString:@"kline"]) {
        [self _matchKLineWithMessage:message domain:domain channel:channel];
    } else if ([channel containsString:@"balance"]) {
        [self _matchBalanceWithMessage:message domain:domain channel:channel];
    } else if ([channel containsString:@"order"]) {
        [self _matchOrderWithMessage:message domain:domain channel:channel];
    }
}

- (void)_matchTickerWithMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXTicker *ticker = [message modelOfClass:[EXTicker class] error:&error];
    ticker.symbol = symbol;
    ticker.exchangeDomain = domain;
    
    if (error) return;
    
    [self _handleTicker:ticker];
}

- (void)_matchDepthWithMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXDepthSet *depthSet = [message modelOfClass:[EXDepthSet class] error:&error];
    if (error) return;
    
    [depthSet.asks setValue:symbol forKey:@keypath(EXDepth.new, symbol)];
    [depthSet.asks setValue:domain forKey:@keypath(EXDepth.new, exchangeDomain)];
    
    [depthSet.bids setValue:symbol forKey:@keypath(EXDepth.new, symbol)];
    [depthSet.bids setValue:domain forKey:@keypath(EXDepth.new, exchangeDomain)];
    
    [self _handleDepthSet:depthSet symbol:symbol domain:domain];
}

- (void)_matchTradeWithMessage:(NSArray *)message domain:(NSString *)domain channel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSMutableArray<EXTrade *> *trades = [NSMutableArray array];
    for (NSArray *infos in message) {
        NSString *objectID = [infos firstObject];
        double price = [infos.count > 1 ? infos[1] : nil doubleValue];
        double amount = [infos.count > 2 ? infos[2] : nil doubleValue];
        
        NSString *timeString = infos.count > 3 ? infos[3] : nil;
        NSTimeInterval time = [[NSDate dateFromString:timeString format:@"HH:mm:ss"] timeIntervalSince1970];
        EXTradeType type = EXTradeTypeFromString(infos.count > 4 ? infos[4] : nil);;
        EXTrade *trade = [EXTrade tradeWithObjectID:objectID price:price amount:amount type:type time:time symbol:symbol domain:domain];
        
        [trades addObject:trade];
    }
    [self _handleTrades:trades symbol:symbol domain:domain];
}

- (void)_matchKLineWithMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
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
        
        EXKLineMetadata *line = [EXKLineMetadata dataWithOpen:open close:close highest:highest lowest:lowest volume:volume time:time symbol:symbol domain:domain];
        [lines addObject:line];
    }
    
    [self _handleKLines:lines symbol:symbol domain:domain];
}

- (void)_matchBalanceWithMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXBalance *balance = [message modelOfClass:[EXBalance class] error:&error];
    balance.symbol = symbol;
    balance.exchangeDomain = domain;
    if (error) return;
    
    [self _handleBalance:balance];
}

- (void)_matchOrderWithMessage:(id)message domain:(NSString *)domain channel:(EXChannelString)channel{
    NSArray *tokens = [channel componentsSeparatedByString:@"_"];
    NSString *symbol = fmts(@"%@_%@", tokens[3], tokens[4]);
    
    NSError *error = nil;
    EXOrder *order = [message modelOfClass:[EXOrder class] error:&error];
    if (error) return;
    
    [self _handleOrder:order forSymbol:symbol];
}

- (void)_handleTicker:(EXTicker *)ticker{
    BOOL state = [self updateTicker:ticker];
    if (!state) EXLogger(@"Failed to update ticker: %@", ticker);
}

- (void)_handleBalance:(EXBalance *)balance{
    BOOL state = [self updateBalance:balance];
    if (!state) EXLogger(@"Failed to update balance: %@", balance);
}

- (void)_handleDepthSet:(EXDepthSet *)depthSet symbol:(NSString *)symbol domain:(NSString *)domain{
    NSString *productID = EXProductID(domain, symbol);
    [self _respondDelegateForUpdatedDepthSet:depthSet forProductID:productID];
}

- (void)_handleTrades:(NSArray<EXTrade *> *)trades symbol:(NSString *)symbol domain:(NSString *)domain{
    NSString *productID = EXProductID(domain, symbol);
    BOOL state = [self insertTrades:trades forProductByID:productID];
    if (!state) EXLogger(@"Failed to insert trades: %@", trades);
}

- (void)_handleKLines:(NSArray<EXKLineMetadata *> *)lines symbol:(NSString *)symbol domain:(NSString *)domain{
    NSString *productID = EXProductID(domain, symbol);
    BOOL state = [self insertKLines:lines forProductByID:productID];
    if (!state) EXLogger(@"Failed to insert klines: %@", lines);
}

- (void)_handleOrder:(EXOrder *)order forSymbol:(NSString *)symbol{
    BOOL exsit = [self exsitOrderByID:order.objectID];
    BOOL state = NO;
    if (exsit) state = [self updateOrder:order];
    else state = [self insertOrder:order];
    
    if (!state) EXLogger(@"Failed to update order: %@", order);
}

@end

@implementation EXProductManager (EXSocketManagerDelegate)

- (void)socketManager:(EXSocketManager *)socketManager channel:(EXChannelString)channel didReceiveMessage:(id)message;{
    [self _handleMessage:message exchange:socketManager.exchange channel:channel];
}

@end
