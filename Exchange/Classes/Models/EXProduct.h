//
//  EXProduct.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@class EXExchange, EXTicker, EXDepth, EXBalance, EXTrade, EXOrder, EXKLineMetadata;
@interface EXProduct : EXModel

@property (nonatomic, copy, readonly) NSString *from;
@property (nonatomic, copy, readonly) NSString *to;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *normalizedSymbol;

@property (nonatomic, assign, readonly) double minimumUnit;

@property (nonatomic, assign, readonly) double precision;

@property (nonatomic, strong, readonly) EXTicker *ticker;

@property (nonatomic, strong, readonly) EXDepth *depth;

@property (nonatomic, copy, readonly) NSArray<EXTrade *> *trades;

@property (nonatomic, copy, readonly) NSArray<EXKLineMetadata *> *lines;

- (NSComparisonResult)compare:(EXProduct *)product;

- (double)rateInExchange:(EXExchange *)exchange;

+ (NSArray<NSString *> *)sortedFromSymbols;
+ (NSArray<NSString *> *)sortedToSymbols;

@end
