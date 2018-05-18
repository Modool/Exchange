//
//  EXCommissionViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACMultipleViewModel.h"

@class EXProduct, EXExchange;
@interface EXCommissionViewModel : RACMultipleViewModel

@property (nonatomic, strong, readonly) EXProduct *product;
@property (nonatomic, strong, readonly) EXExchange *exchange;

@end
