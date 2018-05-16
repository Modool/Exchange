
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
        _collected = product.collected;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, name) = [RACObserve(self, product) mapForKeypath:@keypath(self.product, name)];
    RAC(self, basic) = [RACObserve(self, product) mapForKeypath:@keypath(self.product, basic)];
}

@end
