//
//  EXProductViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableViewModel.h"
#import "EXProductBriefItemViewModel.h"
#import "EXProduct.h"

@class EXExchange;
@interface EXProductViewModel : RACTableViewModel

@property (nonatomic, strong, readonly) EXExchange *exchange;

- (NSArray<EXProductBriefItemViewModel *> *)viewModelsWithProducts:(NSArray<EXProduct *> *)products;
- (EXProductBriefItemViewModel *)viewModelWithProduct:(EXProduct *)product;

@end
