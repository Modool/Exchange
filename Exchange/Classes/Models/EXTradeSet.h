//
//  EXTradeSet.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"
#import "EXTrade.h"

@interface EXTradeSet : EXModel

@property (nonatomic, assign, readonly) BOOL buy;

@property (nonatomic, assign, readonly) double price;

@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, copy) NSArray<EXTrade *> *trades;

+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy;
+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy trades:(NSArray<EXTrade *> *)trades;

- (instancetype)initWithPrice:(double)price buy:(BOOL)buy;
- (instancetype)initWithPrice:(double)price buy:(BOOL)buy trades:(NSArray<EXTrade *> *)trades;

@end
