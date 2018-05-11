
//
//  EXProductBriefItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductBriefItemViewModel.h"
#import "EXProductManager.h"

@implementation EXProductBriefItemViewModel

+ (instancetype)viewModelWithProduct:(EXProduct *)product;{
    return [[self alloc] initWithProduct:product];
}

- (instancetype)initWithProduct:(EXProduct *)product;{
    if (self = [super init]) {
        _product = product;
        
        __block BOOL collected = NO;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            collected = [accessor isCollectedProductForSymbol:product.symbol];
        }];
        
        _collected = collected;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, from) = [RACObserve(self, product) mapForKeypath:@keypath(self.product, from)];
    RAC(self, to) = [RACObserve(self, product) mapForKeypath:@keypath(self.product, to)];
}

@end
