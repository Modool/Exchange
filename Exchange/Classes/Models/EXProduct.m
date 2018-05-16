//
//  EXProduct.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProduct.h"
#import "EXProduct+Private.h"
#import "EXProductManager.h"
#import "EXExchange.h"

@implementation EXProduct

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXProduct *product;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(product, objectID): @"id",
               @keypath(product, symbol): @"symbol",
               @keypath(product, minimumUnit): @"minimum_unit",
               @keypath(product, precision): @"precision",
               @keypath(product, exchangeDomain): @"exchange_domain",
               @keypath(product, collected): @"collected",
               }];
}

+ (NSArray<NSString *> *)sortedFromSymbols;{
    static NSArray<NSString *> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = @[@"btc", @"eth", @"etc", @"eos", @"xlm", @"itc", @"uip", @"pix"];;
    });
    return symbols;
}

+ (NSArray<NSString *> *)sortedToSymbols;{
    static NSArray<NSString *> *symbols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        symbols = @[@"btc", @"usdt", @"eth", @"cny"];
    });
    return symbols;
}

- (NSComparisonResult)compare:(EXProduct *)product;{
    NSArray<NSString *> *fromSymbols = self.class.sortedFromSymbols;
    NSArray<NSString *> *toSymbols = self.class.sortedToSymbols;
    
    NSUInteger index1 = [toSymbols indexOfObject:self.basic];
    NSUInteger index2 = [toSymbols indexOfObject:product.basic];
    NSComparisonResult result = index1 < index2 ? NSOrderedAscending : (index1 > index2 ? NSOrderedDescending : NSOrderedSame);
    
    if (result != NSOrderedSame) return result;
    
    index1 = [fromSymbols indexOfObject:self.name];
    index2 = [fromSymbols indexOfObject:product.name];
    
    if (index1 != NSNotFound || index2 != NSNotFound) {
        if (index1 == NSNotFound) return NSOrderedDescending;
        if (index2 == NSNotFound) return NSOrderedAscending;
        if (index1 > index2) return NSOrderedDescending;
        if (index1 < index2) return NSOrderedAscending;
    }
    return [self.name compare:product.name];
}

- (void)setSymbol:(NSString *)symbol{
    if (_symbol != symbol) {
        _symbol = symbol;
        
        NSArray *components = [symbol componentsSeparatedByString:@"_"];
        _name = components.firstObject;
        _basic = components.lastObject;
        
        self.objectID = EXProductID(_exchangeDomain, symbol);
    }
}

- (void)setExchangeDomain:(NSString *)exchangeDomain{
    if (_exchangeDomain != exchangeDomain) {
        _exchangeDomain = exchangeDomain;
        
        self.objectID = EXProductID(exchangeDomain, _symbol);
    }
}

- (NSString *)normalizedSymbol{
    return fmts(@"%@/%@", _name, _basic);
}

- (double)rateInExchange:(EXExchange *)exchange;{
    __block double rate = 0;
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        rate = [accessor rateByExchange:exchange.domain name:self.name basic:self.basic];
    }];
    return rate;
}

@end
