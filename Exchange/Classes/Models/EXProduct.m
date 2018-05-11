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

@implementation EXProduct

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXProduct *product;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(product, objectID): @"id",
               @keypath(product, symbol): @"symbol",
               @keypath(product, minimumUnit): @"minimum_unit",
               @keypath(product, precision): @"precision",
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
    
    NSUInteger index1 = [toSymbols indexOfObject:self.to];
    NSUInteger index2 = [toSymbols indexOfObject:product.to];
    NSComparisonResult result = index1 < index2 ? NSOrderedAscending : (index1 > index2 ? NSOrderedDescending : NSOrderedSame);
    
    if (result != NSOrderedSame) return result;
    
    index1 = [fromSymbols indexOfObject:self.from];
    index2 = [fromSymbols indexOfObject:product.from];
    
    if (index1 != NSNotFound || index2 != NSNotFound) {
        if (index1 == NSNotFound) return NSOrderedDescending;
        if (index2 == NSNotFound) return NSOrderedAscending;
        if (index1 > index2) return NSOrderedDescending;
        if (index1 < index2) return NSOrderedAscending;
    }
    return [self.from compare:product.from];
}

- (void)setSymbol:(NSString *)symbol{
    if (_symbol != symbol) {
        _symbol = symbol;
        
        NSArray *components = [symbol componentsSeparatedByString:@"_"];
        _from = components.firstObject;
        _to = components.lastObject;
    }
}

- (NSString *)normalizedSymbol{
    return fmts(@"%@/%@", _from, _to);
}

- (double)rateInExchange:(EXExchange *)exchange;{
    __block double rate = 0;
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        rate = [accessor rateFromSymbol:self.from toSymbol:self.to exchange:exchange];
    }];
    return rate;
}

@end
