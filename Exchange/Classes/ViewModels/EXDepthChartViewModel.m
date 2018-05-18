//
//  EXDepthChartViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepthChartViewModel.h"
#import "EXDepthChartViewController.h"

@implementation EXDepthChartViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super init]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        
        self.title = @"深度";
        self.viewControllerClass = EXClass(EXDepthChartViewController);
    }
    return self;
}

@end
