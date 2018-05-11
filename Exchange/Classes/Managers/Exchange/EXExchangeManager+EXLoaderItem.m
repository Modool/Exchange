
//
//  EXExchangeManager+EXLoaderItem.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "ACArchiverCenter+EXDefault.h"
#import "EXExchangeManager+EXLoaderItem.h"
#import "EXExchangeManager+Private.h"

#import "EXConstants.h"

NSString * const EXExchangeArchiveStorageKey = @"com.markejave.exchanges.archive.key";

@implementation EXExchangeManager (EXLoaderItem)

- (void)reload;{
    NSMutableDictionary<NSString *, EXExchange *> *exchanges = [NSMutableDictionary dictionary];
    NSDictionary<NSString *, id> *infos = ACArchiverCenter.defaultDeviceStorage[EXExchangeArchiveStorageKey];
    NSArray<NSString *> *domains = [infos allKeys] ?: @[EXExchangeBinanceDomain, EXExchangeOKExDomain, EXExchangeBitfinexDomain, EXExchangeHuobiDomain];
    
    for (NSString *domain in domains) {
        EXExchange *exchange = [EXExchange exchangeWithDomain:domain name:EXExchangeNameFromDomain(domain)];
        exchange.automatic = [infos[domain] boolValue];
        
        exchanges[domain] = exchange;
    }
    self.exchanges = [exchanges copy];
}

- (void)install;{
    
}

@end
