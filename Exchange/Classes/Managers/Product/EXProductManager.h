//
//  EXProductManager.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@class EXProductManager, EXExchange, EXProduct, EXTicker, EXDepthSet, EXDepth, EXTrade, EXTradeSet, EXKLineMetadata, EXBalance, EXOrder;
@protocol EXProductManagerDelegate <NSObject>

@optional
- (void)productManager:(EXProductManager *)productManager didUpdateProduct:(EXProduct *)product collected:(BOOL)collected;

- (void)productManager:(EXProductManager *)productManager didUpdateTicker:(EXTicker *)ticker;

- (void)productManager:(EXProductManager *)productManager didUpdateBalance:(EXBalance *)balance;

- (void)productManager:(EXProductManager *)productManager didAppendOrder:(EXOrder *)order;
- (void)productManager:(EXProductManager *)productManager didUpdateOrder:(EXOrder *)order;

- (void)productManager:(EXProductManager *)productManager didUpdateDepthSet:(EXDepthSet *)depthSet forProductID:(NSString *)productID;

- (void)productManager:(EXProductManager *)productManager didAppendTrades:(NSArray<EXTrade *> *)trades forProductID:(NSString *)productID;
- (void)productManager:(EXProductManager *)productManager didAppendKLines:(NSArray<EXKLineMetadata *> *)lines forProductID:(NSString *)productID;

@end

@protocol EXProductManagerSymbolDelegate <NSObject>

@optional
- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateProduct:(EXProduct *)product collected:(BOOL)collected;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateTicker:(EXTicker *)ticker;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateBalance:(EXBalance *)balance;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didAppendOrder:(EXOrder *)order;
- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateOrder:(EXOrder *)order;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateDepthSet:(EXDepthSet *)depthSet;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didAppendTrades:(NSArray<EXTrade *> *)trades;

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didAppendKLines:(NSArray<EXKLineMetadata *> *)lines;

@end

@protocol EXProductManager <NSObject>

- (double)rateByExchange:(NSString *)domain name:(NSString *)name basic:(NSString *)basic;

- (EXProduct *)productByProductID:(NSString *)productID;

- (EXBalance *)balanceByExchange:(NSString *)domain symbol:(NSString *)symbol;
- (EXTicker *)tickerByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (NSArray<EXProduct *> *)products;
- (NSArray<EXProduct *> *)productsAtPage:(NSUInteger)page size:(NSUInteger)size;
- (NSArray<EXProduct *> *)productsWithKeyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;

- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain;
- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain page:(NSUInteger)page size:(NSUInteger)size;
- (NSArray<EXProduct *> *)productsByExchange:(NSString *)domain keyword:(NSString *)keyword page:(NSUInteger)page size:(NSUInteger)size;

- (NSArray<EXProduct *> *)collectedProducts;
- (NSArray<EXProduct *> *)collectedProductsAtPage:(NSUInteger)page size:(NSUInteger)size;

- (NSArray<EXProduct *> *)collectedProductsByExchange:(NSString *)domain;
- (NSArray<EXProduct *> *)collectedProductsByExchange:(NSString *)domain page:(NSUInteger)page size:(NSUInteger)size;

- (NSArray<EXBalance *> *)balancesByExchange:(NSString *)domain;
- (NSArray<EXTicker *> *)tickersByExchange:(NSString *)domain;

- (NSArray<EXDepth *> *)depthsByExchange:(NSString *)domain symbol:(NSString *)symbol;
- (NSArray<EXDepth *> *)depthsByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;

- (NSArray<EXTrade *> *)tradesByExchange:(NSString *)domain symbol:(NSString *)symbol;
- (NSArray<EXTrade *> *)tradesByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;

- (NSArray<EXOrder *> *)ordersByExchange:(NSString *)domain;
- (NSArray<EXOrder *> *)ordersByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (BOOL)exsitOrderByID:(NSString *)orderID;

#pragma mark - insert

- (BOOL)insertTrade:(EXTrade *)trade;
- (BOOL)insertTrades:(NSArray<EXTrade *> *)trades forProductByID:(NSString *)productID;
- (BOOL)insertKLines:(NSArray<EXKLineMetadata *> *)lines forProductByID:(NSString *)productID;

- (BOOL)insertOrder:(EXOrder *)order;

#pragma mark - update

- (BOOL)updateProductByID:(NSString *)productID collected:(BOOL)collected;

- (BOOL)updateTicker:(EXTicker *)ticker;
- (BOOL)updateBalance:(EXBalance *)balance;
- (BOOL)updateOrder:(EXOrder *)order;

#pragma mark - delegate

- (void)addDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forProductID:(NSString *)productID;
- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue forProductID:(NSString *)productID;
- (void)removeDelegate:(id<EXProductManagerSymbolDelegate>)delegate forProductID:(NSString *)productID;
- (void)removeDelegatesByProductID:(NSString *)productID;

@end

@interface EXProductManager : EXDelegatesAccessor

+ (void)sync:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;
+ (void)async:(void (^)(EXDelegatesAccessor<EXProductManager> *accessor))block;

@end
