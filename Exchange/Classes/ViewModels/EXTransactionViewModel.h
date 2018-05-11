//
//  EXTransactionViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableViewModel.h"
#import "EXProductItemViewModel.h"
#import "EXProduct.h"

@interface EXTransactionViewModel : RACTableViewModel

@property (nonatomic, strong, readonly) RACCommand *collectCommand;

- (EXProductItemViewModel *)viewModelOfProduct:(EXProduct *)product;

- (EXProductItemViewModel *)viewModelWithProduct:(EXProduct *)product;
- (NSArray<EXProductItemViewModel *> *)viewModelsWithProducts:(NSArray<EXProduct *> *)products;

@end
