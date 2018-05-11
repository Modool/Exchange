//
//  EXBalanceViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableViewModel.h"
#import "EXBalanceItemViewModel.h"

@class EXExchange;
@interface EXBalanceViewModel : RACTableViewModel

@property (nonatomic, strong, readonly) NSArray<EXBalanceItemViewModel *> *viewModels;

@property (nonatomic, strong, readonly) RACCommand *hideCommand;

@property (nonatomic, assign, readonly) BOOL hide;

@property (nonatomic, copy, readonly) NSString *rightBarButtonItemTitle;

@end
