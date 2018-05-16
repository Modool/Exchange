//
//  EXProductManager+Database.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"
#import "EXDepth.h"

@interface EXProductManager (Database)

- (EXProduct *)_productByProductID:(NSString *)productID;

- (EXBalance *)_balanceByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (EXTicker *)_tickerByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (NSArray<EXProduct *> *)_productsByExchange:(NSString *)domain keyword:(NSString *)keyword range:(NSRange)range;

- (NSArray<EXProduct *> *)_collectedProductsInRange:(NSRange)range;
- (NSArray<EXProduct *> *)_collectedProductsByExchange:(NSString *)domain range:(NSRange)range;

- (NSArray<EXBalance *> *)_balancesByExchange:(NSString *)domain;
- (NSArray<EXTicker *> *)_tickersByExchange:(NSString *)domain;

- (NSArray<EXDepth *> *)_depthsByExchange:(NSString *)domain symbol:(NSString *)symbol;
- (NSArray<EXDepth *> *)_depthsByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;

- (NSArray<EXTrade *> *)_tradesByExchange:(NSString *)domain symbol:(NSString *)symbol;
- (NSArray<EXTrade *> *)_tradesByExchange:(NSString *)domain symbol:(NSString *)symbol buy:(BOOL)buy;

- (NSArray<EXOrder *> *)_ordersByExchange:(NSString *)domain;
- (NSArray<EXOrder *> *)_ordersByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (NSArray<EXKLineMetadata *> *)_linesByExchange:(NSString *)domain symbol:(NSString *)symbol;

- (BOOL)_exsitOrderByID:(NSString *)orderID;

#pragma mark - insert

- (BOOL)_insertProductsWithBlock:(EXProduct *(^)(NSUInteger index, BOOL *stop))block block:(void (^)(BOOL state, UInt64 rowID, NSUInteger index, BOOL *stop))resultBlock;
- (BOOL)_insertTrade:(EXTrade *)trade;
- (BOOL)_insertTrades:(NSArray<EXTrade *> *)trades;
- (BOOL)_insertKLines:(NSArray<EXKLineMetadata *> *)lines;

- (BOOL)_insertOrder:(EXOrder *)order;

#pragma mark - update

- (BOOL)_updateProductByID:(NSString *)productID collected:(BOOL)collected;

- (BOOL)_updateTicker:(EXTicker *)ticker;
- (BOOL)_updateBalance:(EXBalance *)balance;
- (BOOL)_updateOrder:(EXOrder *)order;

@end
