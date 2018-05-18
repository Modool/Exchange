//
//  EXProductDetailViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"
#import "EXProductDetailTickerViewModel.h"

@interface EXProductDetailViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) EXProductDetailTickerViewModel *tickerViewModel;

@property (nonatomic, strong, readonly) EXProduct *product;
@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) RACCommand *collectCommand;
@property (nonatomic, strong, readonly) RACCommand *analyseCommand;

@property (nonatomic, assign, readonly) BOOL collected;

@property (nonatomic, copy) void (^collection)(EXProduct *product, BOOL collected);

@end
