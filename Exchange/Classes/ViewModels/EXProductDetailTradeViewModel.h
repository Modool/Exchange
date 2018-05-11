//
//  EXProductDetailTradeViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXProduct.h"
#import "EXExchange.h"
#import "EXTrade.h"

@interface EXProductDetailTradeViewModel : RACViewModel

@property (nonatomic, copy) NSArray<EXTrade *> *buyTrades;
@property (nonatomic, copy) NSArray<EXTrade *> *sellTrades;

@end
