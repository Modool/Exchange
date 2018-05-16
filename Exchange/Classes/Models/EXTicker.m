//
//  EXTicker.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTicker.h"
#import "EXTicker+Private.h"

@implementation EXTicker

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXTicker *ticker;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(ticker, objectID): @"id",
               @keypath(ticker, exchangeDomain): @"exchange_domain",
               @keypath(ticker, openPrice): @"open",
               @keypath(ticker, closePrice): @"close",
               @keypath(ticker, currentBuyPrice): @"buy",
               @keypath(ticker, currentSellPrice): @"sell",
               @keypath(ticker, highestPrice): @"high",
               @keypath(ticker, lowestPrice): @"low",
               @keypath(ticker, lastestPrice): @"last",
               @keypath(ticker, volume): @"vol",
               @keypath(ticker, offset): @"change",
               @keypath(ticker, dayLowPrice): @"dayLow",
               @keypath(ticker, dayHightPrice): @"dayHigh",
               @keypath(ticker, time): @"timestamp",
               }];
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end
