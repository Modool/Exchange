//
//  EXTradeItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXTrade.h"

@interface EXTradeItemViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXTrade *trade;

@property (nonatomic, assign, readonly) BOOL buy;

@property (nonatomic, assign, readonly) double price;

@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, copy, readonly) NSString *timeString;

- (instancetype)initWithTrade:(EXTrade *)trade;

@end
