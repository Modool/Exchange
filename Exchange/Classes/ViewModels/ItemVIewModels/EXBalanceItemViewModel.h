//
//  EXBalanceItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"

#import "EXBalance.h"

@interface EXBalanceItemViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXBalance *balance;

@property (nonatomic, copy, readonly) NSString *symbol;

@property (nonatomic, assign, readonly) double free;

@property (nonatomic, assign, readonly) double freezed;

@property (nonatomic, assign, readonly) double all;

- (instancetype)initWithBalance:(EXBalance *)balance;

@end
