//
//  EXExchangeManager.h
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@class EXExchange, EXExchangeManager;
@protocol EXExchangeManagerDelegate <NSObject>

- (void)exchangeManager:(EXExchangeManager *)exchangeManager didUpdateExchange:(EXExchange *)exchange;

@end

@protocol EXExchangeManager <NSObject>

- (NSArray<EXExchange *> *)allExchanges;

- (EXExchange *)exchangeByDomain:(NSString *)domain;

@end

@interface EXExchangeManager : EXDelegatesAccessor

+ (void)sync:(void (^)(EXDelegatesAccessor<EXExchangeManager> *accessor))block;
+ (void)async:(void (^)(EXDelegatesAccessor<EXExchangeManager> *accessor))block;

@end
