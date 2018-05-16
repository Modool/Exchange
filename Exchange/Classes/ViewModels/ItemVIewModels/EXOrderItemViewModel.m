
//
//  EXOrderItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOrderItemViewModel.h"

@implementation EXOrderItemViewModel

+ (instancetype)viewModelWithOrder:(EXOrder *)order;{
    return [[self alloc] initWithOrder:order];
}

- (instancetype)initWithOrder:(EXOrder *)order;{
    if (self = [super init]) {
        _order = order;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, orderID) = RACObserve(self.order, objectID);
    RAC(self, name) = RACObserve(self.order, name);
    RAC(self, basic) = RACObserve(self.order, basic);
    RAC(self, type) = RACObserve(self.order, type);
    RAC(self, amount) = RACObserve(self.order, amount);
    RAC(self, dealAmount) = RACObserve(self.order, dealAmount);
    RAC(self, price) = RACObserve(self.order, price);
    RAC(self, dealPrice) = [RACSignal combineLatest:@[RACObserve(self.order, dealAmount), RACObserve(self.order, averagePrice)] reduce:^id(NSNumber *amount, NSNumber *price){
        return @(amount.doubleValue * price.doubleValue);
    }];
    RAC(self, averagePrice) = RACObserve(self.order, averagePrice);
    RAC(self, status) = RACObserve(self.order, status);
    RAC(self, time) = RACObserve(self.order, time);
}

@end
