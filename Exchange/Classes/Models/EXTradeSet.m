//
//  EXTradeSet.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeSet.h"

@implementation EXTradeSet

+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy amount:(double)amount count:(NSUInteger)count;{
    return [[self alloc] initWithPrice:price buy:buy amount:amount count:count];
}

- (instancetype)initWithPrice:(double)price buy:(BOOL)buy amount:(double)amount count:(NSUInteger)count;{
    if (self = [super init]) {
        self.price = price;
        self.buy = buy;
        self.amount = amount;
        self.count = count;
    }
    return self;
}

- (NSUInteger)hash{
    return @(self.price).hash ^ @(self.buy).hash ^ self.class.hash;
}

- (BOOL)isEqual:(EXTradeSet *)object{
    if (![object isKindOfClass:[EXTradeSet class]]) return NO;
    
    return object.price == self.price && object.buy == self.buy;
}

@end
