//
//  EXExchangeEntranceItemViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeEntranceItemViewModel.h"
#import "EXExchange.h"

@implementation EXExchangeEntranceItemViewModel
@dynamic exchange;

- (instancetype)initWithExchange:(EXExchange *)exchange;{
    if (self = [super initWithExchange:exchange]) {
        self.height = 80;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, name) = [RACObserve(self, exchange) mapForKeypath:@keypath(self.exchange, name)];
    RAC(self, automatic) = [RACObserve(self, exchange) mapForKeypath:@keypath(self.exchange, automatic)];
    RAC(self, APIKey) = [[RACObserve(self, exchange) mapForKeypath:@keypath(self.exchange, APIKey)] map:^id(NSString *APIKey) {
        return [APIKey length] > 8 ? fmts(@"****%@****", [APIKey substringWithRange:NSMakeRange(4, APIKey.length - 8)]) : @"****";
    }];
    RAC(self, secretKey) = [[RACObserve(self, exchange) mapForKeypath:@keypath(self.exchange, secretKey)] map:^id(NSString *secretKey) {
        return [secretKey length] > 8 ? fmts(@"****%@****", [secretKey substringWithRange:NSMakeRange(4, secretKey.length - 8)]) : @"****";
    }];
    RAC(self, rateDescription) = [[RACObserve(self, exchange) mapForKeypath:@keypath(self.exchange, CNYRate)] map:^id(NSNumber *value) {
        return fmts(@"USDT/CNY %.8f", value.doubleValue);
    }];
}

@end
