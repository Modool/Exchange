 //
//  EXExchange.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <CategoryKit/CategoryKit.h>
#import "EXExchange.h"
#import "EXKeychain.h"
#import "EXHTTPClient.h"
#import "EXConstants.h"

NSString * const EXExchangeBinanceEndpoint = @"https://api.binance.com";
NSString * const EXExchangeBinanceWebSocketEndpoint = @"https://api.binance.com";

NSString * const EXExchangeOKCoinEndpoint = @"https://www.okex.com";
NSString * const EXExchangeOKCoinWebSocketEndpoint = @"wss://real.okex.com:10441/websocket";

NSString * const EXExchangeBitfinexEndpoint = @"https://api.bitfinex.com";
NSString * const EXExchangeBitfinexWebSocketEndpoint = @"https://api.bitfinex.com";

NSString * const EXExchangeHuobiEndpoint = @"https://api.huobi.pro";
NSString * const EXExchangeHuobiWebSocketEndpoint = @"https://api.huobi.pro";

@interface EXExchange ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *domain;

@end

@implementation EXExchange
@dynamic APIKey, secretKey;

+ (instancetype)exchangeWithDomain:(NSString *)domain name:(NSString *)name;{
    return [[self alloc] initWithDomain:domain name:name];
}

- (instancetype)initWithDomain:(NSString *)domain name:(NSString *)name;{
    if (self = [super init]) {
        self.domain = domain;
        self.name = name;
    }
    return self;
}

#pragma mark - accessor

- (NSString *)identifier{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)USDRateKeychainName {
    return [fmts(@"com.markejave.exchange.usd.rate.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (NSString *)CNYRateKeychainName {
    return [fmts(@"com.markejave.exchange.cny.rate.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (NSString *)TWDRateKeychainName {
    return [fmts(@"com.markejave.exchange.twd.rate.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (NSString *)HKDRateKeychainName {
    return [fmts(@"com.markejave.exchange.hkd.rate.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (NSString *)appKeyKeychainName {
    return [fmts(@"com.markejave.exchange.app.key.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (NSString *)appSecretKeychainName {
    return [fmts(@"com.markejave.exchange.app.secret.%@.%@", [self identifier], [self domain]) encodeMD5];
}

- (void)setUSDRate:(double)USDRate{
    [EXKeychain setPassword:[@(USDRate) description] forKey:[self USDRateKeychainName]];
}

- (double)USDRate{
    return [[EXKeychain passwordForKey:[self USDRateKeychainName]] doubleValue];
}

- (void)setCNYRate:(double)CNYRate{
    [EXKeychain setPassword:[@(CNYRate) description] forKey:[self CNYRateKeychainName]];
}

- (double)CNYRate{
    return [[EXKeychain passwordForKey:[self CNYRateKeychainName]] doubleValue];
}

- (void)setTWDRate:(double)TWDRate{
    [EXKeychain setPassword:[@(TWDRate) description] forKey:[self TWDRateKeychainName]];
}

- (double)TWDRate{
    return [[EXKeychain passwordForKey:[self TWDRateKeychainName]] doubleValue];
}

- (void)setHKDRate:(double)HKDRate{
    [EXKeychain setPassword:[@(HKDRate) description] forKey:[self HKDRateKeychainName]];
}

- (double)HKDRate{
    return [[EXKeychain passwordForKey:[self HKDRateKeychainName]] doubleValue];
}

- (double)currentRate {
    switch (self.rateType) {
        case EXExchangeRateTypeUSD: return self.USDRate;
        case EXExchangeRateTypeCNY: return self.CNYRate;
        case EXExchangeRateTypeTWD: return self.TWDRate;
        case EXExchangeRateTypeHKD: return self.HKDRate;
        default: return 0;
    }
}

- (void)setAPIKey:(NSString *)APIKey{
    [EXKeychain setPassword:APIKey forKey:[self appKeyKeychainName]];
}

- (NSString *)APIKey{
    return [EXKeychain passwordForKey:[self appKeyKeychainName]];
}

- (void)setSecretKey:(NSString *)secretKey{
    [EXKeychain setPassword:secretKey forKey:[self appSecretKeychainName]];
}

- (NSString *)secretKey{
    return [EXKeychain passwordForKey:[self appSecretKeychainName]];
}

- (NSURL *)baseURL{
    static NSDictionary *URLMapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URLMapper = @{EXExchangeBinanceDomain: EXExchangeBinanceEndpoint,
                      EXExchangeOKExDomain: EXExchangeOKCoinEndpoint,
                      EXExchangeBitfinexDomain: EXExchangeBitfinexEndpoint,
                      EXExchangeHuobiDomain: EXExchangeHuobiEndpoint,
                      };
    });
    
    return [NSURL URLWithString:URLMapper[[self domain]]];
}

- (NSURL *)webSocketURL{
    static NSDictionary *URLMapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URLMapper = @{EXExchangeBinanceDomain: EXExchangeBinanceWebSocketEndpoint,
                      EXExchangeOKExDomain: EXExchangeOKCoinWebSocketEndpoint,
                      EXExchangeBitfinexDomain: EXExchangeBitfinexWebSocketEndpoint,
                      EXExchangeHuobiDomain: EXExchangeHuobiWebSocketEndpoint,
                      };
    });
    
    return [NSURL URLWithString:URLMapper[[self domain]]];
}

- (id<EXHTTPClient>)client{
    return [EXHTTPClient clientWithExchange:self];
}

@end
