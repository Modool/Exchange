//
//  EXRootViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXRootViewModel.h"
#import "EXRootViewController.h"

#import "EXMarketViewModel.h"
#import "EXTradeViewModel.h"
#import "EXUserViewModel.h"

@interface EXRootViewModel ()

@end

@implementation EXRootViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.viewControllerClass = EXClass(EXRootViewController);
        
        EXMarketViewModel *market = [[EXMarketViewModel alloc] initWithServices:services params:nil];
        EXTradeViewModel *order = [[EXTradeViewModel alloc] initWithServices:services params:nil];
        EXUserViewModel *user = [[EXUserViewModel alloc] initWithServices:services params:nil];
        self.viewModels = @[market, order, user];
    }
    return self;
}

@end
