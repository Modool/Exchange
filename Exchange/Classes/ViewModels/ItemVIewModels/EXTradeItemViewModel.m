
//
//  EXTradeItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeItemViewModel.h"

@implementation EXTradeItemViewModel

- (instancetype)initWithTrade:(EXTrade *)trade;{
    if (self = [super init]) {
        _trade = trade;
        _buy = trade.buy;
        _amount = trade.amount;
        _price = trade.price;
        _timeString = [[NSDate dateWithTimeIntervalSince1970:trade.time] dateStringWithFormat:@"HH:mm:ss"];
    }
    return self;
}

@end
