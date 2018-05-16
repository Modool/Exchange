//
//  EXTradeSet.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeSet.h"

@implementation EXTradeSet

+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy;{
    return [self setWithPrice:price buy:buy trades:nil];
}

+ (instancetype)setWithPrice:(double)price buy:(BOOL)buy trades:(NSArray<EXTrade *> *)trades;{
    return [[self alloc] initWithPrice:price buy:buy trades:trades];
}

- (instancetype)initWithPrice:(double)price buy:(BOOL)buy;{
    return [self initWithPrice:price buy:buy trades:nil];
}

- (instancetype)initWithPrice:(double)price buy:(BOOL)buy trades:(NSArray<EXTrade *> *)trades;{
    if (self = [super init]) {
        _buy = buy;
        _price = price;
        
        self.trades = trades;
    }
    return self;
}

- (void)setTrades:(NSArray<EXTrade *> *)trades{
    if (_trades != trades) {
        _trades = trades;
        
        _amount = [[trades valueForKeyPath:@"@sum.amount"] doubleValue];
    }
}

- (NSUInteger)count{
    return self.trades.count;
}

- (NSUInteger)hash{
    return @(self.price).hash ^ @(self.buy).hash ^ self.class.hash;
}

- (BOOL)isEqual:(EXTradeSet *)object{
    if (![object isKindOfClass:[EXTradeSet class]]) return NO;
    
    return object.price == self.price && object.buy == self.buy;
}


@end
