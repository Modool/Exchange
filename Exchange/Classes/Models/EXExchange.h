//
//  EXExchange.h
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXModel.h"
#import "EXConstants.h"

@protocol EXHTTPClient;
@interface EXExchange : EXModel

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *secretKey;

// Default is 1.f;
@property (nonatomic, assign) double USDRate;
// usdt - cny
@property (nonatomic, assign) double CNYRate;

@property (nonatomic, assign) double TWDRate;

@property (nonatomic, assign) double HKDRate;

@property (nonatomic, assign) EXExchangeRateType rateType;
@property (nonatomic, assign, readonly) double currentRate;

@property (nonatomic, assign, getter=isAutomatic) BOOL automatic;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *domain;

@property (nonatomic, copy, readonly) NSURL *baseURL;
@property (nonatomic, copy, readonly) NSURL *webSocketURL;

@property (nonatomic, strong, readonly) id<EXHTTPClient> client;

+ (instancetype)exchangeWithDomain:(NSString *)domain name:(NSString *)name;
- (instancetype)initWithDomain:(NSString *)domain name:(NSString *)name;

@end
