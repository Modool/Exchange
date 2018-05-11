//
//  EXOKExHTTPClient+EXOrder.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"

@interface EXOKExHTTPClient (EXOrder)<EXHTTPClientOrder>

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
