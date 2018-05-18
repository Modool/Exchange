//
//  EXTradeRecordsViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableViewModel.h"
#import "EXProduct.h"
#import "EXExchange.h"
#import "EXTrade.h"

@interface EXTradeRecordsViewModel : RACTableViewModel

@property (nonatomic, strong, readonly) EXProduct *product;
@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) RACCommand *depthCommand;

@end
