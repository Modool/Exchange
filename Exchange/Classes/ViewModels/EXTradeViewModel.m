//
//  EXTradeViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXTradeViewModel.h"
#import "EXTradeViewController.h"

@implementation EXTradeViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"交易";
        self.style = UITableViewStyleGrouped;
        self.viewControllerClass = EXClass(EXTradeViewController);
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[self title] image:EXImageNamed(@"img_order_n") tag:0];
    }
    return self;
}

@end
