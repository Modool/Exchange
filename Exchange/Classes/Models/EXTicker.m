//
//  EXTicker.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTicker.h"

@interface EXTicker ()

@property (nonatomic, assign) double openPrice;
@property (nonatomic, assign) double closePrice;

@property (nonatomic, assign) double currentBuyPrice;
@property (nonatomic, assign) double currentSellPrice;

@property (nonatomic, assign) double highestPrice;
@property (nonatomic, assign) double lowestPrice;

@property (nonatomic, assign) double lastestPrice;

@property (nonatomic, assign) double offset;
@property (nonatomic, assign) double dayLowPrice;
@property (nonatomic, assign) double dayHightPrice;

@property (nonatomic, assign) double volume;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXTicker

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXTicker *ticker;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
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

@end
