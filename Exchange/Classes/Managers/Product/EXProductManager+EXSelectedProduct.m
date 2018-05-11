//
//  EXProductManager+EXSelectedProduct.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/28.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+EXSelectedProduct.h"
#import "EXProductManager+Private.h"
#import "ACArchiverCenter+EXDefault.h"

NSString * EXProductManagerCollectedSymbolArchiverKey = @"com.markejave.exchange.collected.symbols";

@implementation EXProductManager (EXSelectedProduct)

- (void)_saveCollectedProduct;{
    NSArray<NSString *> *symbols = self.collectedSymbols.copy;
    
    ACArchiverCenter.defaultDeviceStorage[EXProductManagerCollectedSymbolArchiverKey] = symbols;
}

- (void)_readCollectedProduct;{
    NSArray<NSString *> *symbols = ACArchiverCenter.defaultDeviceStorage[EXProductManagerCollectedSymbolArchiverKey];
    if (!symbols.count) symbols = @[@"eos_btc", @"itc_btc", @"etc_btc", @"xlm_btc"];
    
    self.collectedSymbols = [NSMutableArray arrayWithArray:symbols];
}

- (void)_respondDelegateForCollectedSymbol:(NSString *)symbol;{
    EXProduct *product = [self productBySymbol:symbol];
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didCollectProduct:)]) {
        [[self delegates] productManager:self symbol:symbol didCollectProduct:product];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didCollectProduct:forSymbol:)]) {
        [delegates productManager:self didCollectProduct:product forSymbol:symbol];
    }
}

- (void)_respondDelegateForDescollectedSymbol:(NSString *)symbol;{
    EXProduct *product = [self productBySymbol:symbol];
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(productManager:symbol:didDescollectProduct:)]) {
        [[self delegates] productManager:self symbol:symbol didDescollectProduct:product];
    }
    MDMulticastDelegate<EXProductManagerSymbolDelegate> *delegates = [self _delegatesForSymbol:symbol];
    if ([delegates hasDelegateThatRespondsToSelector:@selector(productManager:didDescollectProduct:forSymbol:)]) {
        [delegates productManager:self didDescollectProduct:product forSymbol:symbol];
    }
}

@end
