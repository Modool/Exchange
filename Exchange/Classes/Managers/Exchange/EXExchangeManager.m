//
//  EXExchangeManager.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeManager.h"
#import "EXExchangeManager+Private.h"

@implementation EXExchangeManager

+ (void)sync:(void (^)(EXDelegatesAccessor<EXExchangeManager> *accessor))block;{
    [super sync:block];
}

+ (void)async:(void (^)(EXDelegatesAccessor<EXExchangeManager> *accessor))block;{
    [super async:block];
}

- (NSArray<EXExchange *> *)allExchanges;{
    return [[self exchanges] allValues];
}

- (EXExchange *)exchangeByDomain:(NSString *)domain;{
    return self.exchanges[domain];
}

@end

