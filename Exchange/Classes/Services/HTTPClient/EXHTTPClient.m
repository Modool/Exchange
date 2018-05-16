//
//  EXHTTPClient.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient.h"
#import "EXHTTPClient+Private.h"

#import "EXExchange.h"
#import "EXConstants.h"

@interface EXHTTPClient ()

@property (nonatomic, strong) EXExchange *exchange;

@end

@implementation EXHTTPClient

+ (id<EXHTTPClient>)clientWithExchange:(EXExchange *)exchange;{
    return [self requireClientWithExchange:exchange];
}

+ (id<EXHTTPClient>)clientForExchange:(EXExchange *)exchange{
    Class class = self.clientMapper[[exchange domain]];
    
    return [[class alloc] initWithExchange:exchange];
}

- (instancetype)initWithExchange:(EXExchange *)exchange;{
    if (self = [super initWithBaseURL:[exchange baseURL]]) {
        self.exchange = exchange;
    }
    return self;
}

- (NSString *)APIKey{
    return self.exchange.APIKey;
}

- (NSString *)secretKey{
    return self.exchange.secretKey;
}

+ (NSDictionary<NSString *, Class> *)clientMapper{
    static NSDictionary<NSString *, Class> *mapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = @{EXExchangeBinanceDomain: [EXBinanceHTTPClient class],
                   EXExchangeOKExDomain: [EXOKExHTTPClient class],
                   EXExchangeBitfinexDomain: [EXBitfinexHTTPClient class]
                   };
    });
    return mapper;
}

+ (id<EXHTTPClient>)requireClientWithExchange:(EXExchange *)exchange{
    static NSMutableDictionary<NSString *, id<EXHTTPClient>> *clients = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clients = [NSMutableDictionary new];
    });
    
    @synchronized(self) {
        id<EXHTTPClient> client = clients[[exchange domain]];
        if (!client) {
            client = [self clientForExchange:exchange];
            clients[[exchange domain]] = client;
        }
        return client;
    }
}

@end
