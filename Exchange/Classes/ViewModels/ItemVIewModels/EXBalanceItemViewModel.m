

//
//  EXBalanceItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalanceItemViewModel.h"

@implementation EXBalanceItemViewModel

- (instancetype)initWithBalance:(EXBalance *)balance;{
    if (self = [super init]) {
        _balance = balance;
        _symbol = balance.symbol.copy;
        _free = balance.free;
        _freezed = balance.freezed;
    }
    return self;
}

- (double)all{
    return self.balance.all;
}

@end
