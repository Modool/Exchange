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

@property (nonatomic, assign) BOOL buy;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double amount;

@property (nonatomic, assign) NSUInteger count;

+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy amount:(double)amount count:(NSUInteger)count;
- (instancetype)initWithPrice:(double)price buy:(BOOL)buy amount:(double)amount count:(NSUInteger)count;

@end
