
//
//  EXSocketManager+EXLoaderItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "EXSocketManager+EXLoaderItem.h"
#import "EXSocketManager+Private.h"
#import "EXSocketManager+SRWebSocketDelegate.h"

#import "EXExchangeManager.h"
#import "EXProductManager.h"

#import "EXProduct.h"

@implementation EXSocketManager (EXLoaderItem)

- (void)reload{
    self.channels = [NSMutableSet setWithArray:[self requireDefaultChannels]];
    self.reconnectTimeInterval = 1.f;
    __block EXExchange *exchange = nil;
    [EXExchangeManager sync:^(EXDelegatesAccessor<EXExchangeManager> *accessor) {
        exchange = [accessor exchangeByDomain:EXExchangeOKExDomain];
    }];
    self.exchange = exchange;
    
    [self _open];
}

- (void)install{
    RACSignal *deregisterSignal = [self rac_signalForSelector:@selector(uninstall)];
    
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil] takeUntil:deregisterSignal] subscribeToTarget:self performSelector:@selector(_open)];
}

- (NSArray<EXChannelString> *)requireDefaultChannels{
    __block NSArray<NSString *> *symbols = @[@"eos_btc", @"itc_btc", @"etc_btc", @"xlm_btc", @"btc_usdt", @"eth_usdt", @"okb_usdt"];
    
    NSMutableArray<EXChannelString> *channels = [NSMutableArray array];
    for (NSString *symbol in symbols) {
        [channels addObject:[NSString stringWithFormat:EXChannelStringTicker, symbol]];
    }
        
    return channels.copy;
}

@end
