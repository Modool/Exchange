//
//  EXEntranceItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXEntranceItemViewModel.h"
#import "EXExchange.h"

@interface EXEntranceItemViewModel ()

@property (nonatomic, strong) EXExchange *exchange;

@end

@implementation EXEntranceItemViewModel

+ (instancetype)viewModelWithExchange:(EXExchange *)exchange;{
    return [[self alloc] initWithExchange:exchange];
}

- (instancetype)initWithExchange:(EXExchange *)exchange;{
    if (self = [super init]) {
        _exchange = exchange;
        _name = exchange.name;
        _height = 50;
    }
    return self;
}

@end
