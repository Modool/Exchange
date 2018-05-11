//
//  EXOrderViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableViewModel.h"
#import "EXOrderItemViewModel.h"

#import "EXProduct.h"

@interface EXOrderViewModel : RACTableViewModel

@property (nonatomic, strong, readonly) EXProduct *product;

@property (nonatomic, assign, readonly) BOOL finished;

- (NSArray<EXOrderItemViewModel *> *)viewModelsWithOrders:(NSArray<EXOrder *> *)orders;
- (EXOrderItemViewModel *)viewModelWithOrder:(EXOrder *)order;

@end
