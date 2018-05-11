//
//  EXExchangeViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"

@class EXExchange;
@interface EXExchangeViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) RACCommand *saveCommand;
@property (nonatomic, strong, readonly) RACCommand *scanCommand;

@property (nonatomic, copy, readonly) NSString *APIKey;
@property (nonatomic, copy, readonly) NSString *secretKey;

@property (nonatomic, assign, readonly) double CNYRate;

@end
