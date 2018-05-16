//
//  EXHTTPClient.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXRACHTTPClient.h"

EX_EXTERN NSString * EXQueryStringFromParameters(NSDictionary *parameters, NSArray *orderKeys);

@class EXBalance;
@protocol EXHTTPClientUser <NSObject>

// result: NSDictionary
- (RACSignal *)fetchBalancesSignal;

@end

@protocol EXHTTPClientTicker <NSObject>

// result: EXTicker
- (RACSignal *)fetchTickerWithSymbol:(NSString *)symbol;

@end

@protocol EXHTTPClientDepth <NSObject>

// result: EXDepthSet
- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol;

// result: EXDepthSet
- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol size:(NSUInteger /* 200 */)size;

@end

@protocol EXHTTPClientTrade <NSObject>

// result: list of EXTrade
- (RACSignal *)fetchTradesWithSymbol:(NSString *)symbol since:(NSTimeInterval)since;

// result: order id
- (RACSignal *)tradeWithSymbol:(NSString *)symbol type:(EXTradeType)type price:(double)price amount:(double)amount;

// result: list of order id
- (RACSignal *)batchTradeWithSymbol:(NSString *)symbol block:(void (^)(EXTradeType *type, double *price, double *amount, BOOL *stop))block;

@end

@protocol EXHTTPClientKLine <NSObject>

// result: list of EXKLineMetadata
- (RACSignal *)fetchKLinesWithSymbol:(NSString *)symbol type:(EXKLineTimeRangeType)type size:(NSUInteger)size since:(NSTimeInterval)since;

@end

@protocol EXHTTPClientOrder <NSObject>

// result: order id
- (RACSignal *)cancelOrderWithID:(NSString *)orderID symbol:(NSString *)symbol;

// result: {"success":"order_id_1, order_id_2, order_id_3","error":"order_id_1, order_id_2, order_id_3"}
- (RACSignal *)cancelOrdersWithIDs:(NSSet<NSString *> *)orderIDs symbol:(NSString *)symbol;

// result: EXOrder
- (RACSignal *)fetchOrderDetailWithID:(NSString *)orderID symbol:(NSString *)symbol;

// result: list of EXOrder
- (RACSignal *)fetchUnfinishedOrdersWithSymbol:(NSString *)symbol;

// result: list of EXOrder
- (RACSignal *)fetchOrdersWithOrderIDs:(NSSet<NSString *> *)orderIDs symbol:(NSString *)symbol finished:(BOOL)finished;

// result: list of EXOrder
- (RACSignal *)fetchHistoryOrdersWithSymbol:(NSString *)symbol finished:(BOOL)finished page:(NSUInteger)page size:(NSUInteger)size;

@end

@protocol EXHTTPClientWithdraw <NSObject>

- (RACSignal *)withdrawWithSymbol:(NSString *)symbol fee:(double)fee password:(NSString *)password address:(NSString *)address amount:(double)amount target:(NSString *)target;

// result: withdraw id
- (RACSignal *)cancelWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;

// result: EXWithdraw
- (RACSignal *)fetchWithdrawInfoWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;

// result: list of EXAccountRecord
- (RACSignal *)fetchAccountRecordsWithSymbol:(NSString *)symbol withdraw:(BOOL)withdraw page:(NSUInteger)page size:(NSUInteger)size;

@end

@protocol EXHTTPClient <EXHTTPClientUser, EXHTTPClientTicker, EXHTTPClientDepth, EXHTTPClientTrade, EXHTTPClientKLine, EXHTTPClientKLine, EXHTTPClientOrder, EXHTTPClientWithdraw>
@end

@class EXExchange;
@interface EXHTTPClient : EXRACHTTPClient

+ (id<EXHTTPClient>)clientWithExchange:(EXExchange *)exchange;

@end
