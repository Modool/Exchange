//
//  EXProduct.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@class EXExchange, EXTicker, EXDepth, EXBalance, EXTradeSet, EXOrder, EXKLineMetadata;
@interface EXProduct : EXModel

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *basic;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *normalizedSymbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, assign, readonly) double minimumUnit;

@property (nonatomic, assign, readonly) double precision;

@property (nonatomic, assign, readonly) BOOL collected;

- (NSComparisonResult)compare:(EXProduct *)product;

- (double)rateInExchange:(EXExchange *)exchange;

+ (NSArray<NSString *> *)sortedFromSymbols;
+ (NSArray<NSString *> *)sortedToSymbols;

@end
