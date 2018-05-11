//
//  EXProductManager.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@class EXProductManager, EXExchange, EXProduct, EXTicker, EXDepth, EXTrade, EXKLineMetadata, EXBalance, EXOrder;
@protocol EXProductManagerDelegate <NSObject>

@optional
- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didCollectProduct:(EXProduct *)product;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didDescollectProduct:(EXProduct *)product;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didUpdateTicker:(EXTicker *)ticker;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didUpdateBalance:(EXBalance *)balance;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didUpdateOrder:(EXOrder *)order;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didAppendDepth:(EXDepth *)depth;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didAppendTrades:(NSArray<EXTrade *> *)trades;

- (void)productManager:(EXProductManager *)productManager symbol:(NSString *)symbol didAppendKLines:(NSArray<EXKLineMetadata *> *)lines;

@end

@protocol EXProductManagerSymbolDelegate <NSObject>

@optional
- (void)productManager:(EXProductManager *)productManager didCollectProduct:(EXProduct *)product forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didDescollectProduct:(EXProduct *)product forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didUpdateTicker:(EXTicker *)ticker forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didUpdateBalance:(EXBalance *)balance forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didUpdateOrder:(EXOrder *)order forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didAppendDepth:(EXDepth *)depth forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didAppendTrades:(NSArray<EXTrade *> *)trades forSymbol:(NSString *)symbol;

- (void)productManager:(EXProductManager *)productManager didAppendKLines:(NSArray<EXKLineMetadata *> *)lines forSymbol:(NSString *)symbol;

@end

@protocol EXProductManager <NSObject>

- (NSArray<NSString *> *)allSymbols;
- (NSArray<EXProduct *> *)allProducts;
- (NSArray<EXProduct *> *)productsAtPage:(NSUInteger)page size:(NSUInteger)size;
- (NSArray<EXProduct *> *)productsWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;

- (double)rateFromSymbol:(NSString *)fromSymbol toSymbol:(NSString *)toSymbol exchange:(EXExchange *)exchange;

- (EXProduct *)productBySymbol:(NSString *)symbol;

- (NSArray<EXProduct *> *)collectedProducts;
- (NSArray<EXProduct *> *)collectedProductsAtPage:(NSUInteger)page size:(NSUInteger)size;

- (BOOL)isCollectedProductForSymbol:(NSString *)symbol;
- (BOOL)collectProductWithSymbol:(NSString *)symbol;
- (BOOL)descollectProductWithSymbol:(NSString *)symbol;

- (NSArray<EXBalance *> *)balances;

- (EXBalance *)balanceBySymbol:(NSString *)symbol;
- (EXDepth *)depthBySymbol:(NSString *)symbol;
- (EXTicker *)tickerBySymbol:(NSString *)symbol;

- (NSArray<EXTrade *> *)tradesBySymbol:(NSString *)symbol;
- (NSArray<EXKLineMetadata *> *)linesBySymbol:(NSString *)symbol;

- (NSArray<EXOrder *> *)allOrders;
- (NSArray<EXOrder *> *)ordersBySymbol:(NSString *)symbol;

- (void)addDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forSymbol:(NSString *)symbol;
- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forSymbol:(NSString *)symbol;
- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate forSymbol:(NSString *)symbol;

@end

@interface EXProductManager : EXDelegatesAccessor

+ (void)sync:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;
+ (void)async:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;

@end
