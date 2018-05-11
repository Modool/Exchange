//
//  EXOKExHTTPClient+EXOrder.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXOrder.h"
#import "EXOrder.h"

@implementation EXOKExHTTPClient (EXOrder)

- (RACSignal *)cancelOrderWithID:(NSString *)orderID symbol:(NSString *)symbol;{
    NSParameterAssert(orderID.length);
    NSParameterAssert(symbol.length);
    NSDictionary *parameters = @{@"order_id": ntoe(orderID), @"symbol": ntoe(symbol)};
    
    return [self POST:@"/api/v1/trade.do" parameters:parameters resultClass:[NSString class] keyPath:@"order_id"];
}

- (RACSignal *)cancelOrdersWithIDs:(NSSet<NSString *> *)orderIDs symbol:(NSString *)symbol;{
    NSParameterAssert(orderIDs.count <= 3);
    NSParameterAssert(symbol.length);
    
    NSString *orderIDsString = [[orderIDs allObjects] componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"order_id": ntoe(orderIDsString), @"symbol": ntoe(symbol)};
    
    return [self POST:@"/api/v1/trade.do" parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)fetchOrderDetailWithID:(NSString *)orderID symbol:(NSString *)symbol;{
    NSParameterAssert(orderID.length);
    NSParameterAssert(symbol.length);
    NSDictionary *parameters = @{@"order_id": ntoe(orderID), @"symbol": ntoe(symbol)};
    
    return [[[self POST:@"/api/v1/order_info.do" parameters:parameters resultClass:[EXOrder class] keyPath:@"orders"] collect] map:^id(NSArray *value) {
        return value.firstObject;
    }];
}

- (RACSignal *)fetchUnfinishedOrdersWithSymbol:(NSString *)symbol;{
    NSParameterAssert(symbol.length);
    NSDictionary *parameters = @{@"order_id": @"-1", @"symbol": ntoe(symbol)};
    
    return [self POST:@"/api/v1/order_info.do" parameters:parameters resultClass:[EXOrder class] keyPath:@"orders"];
}

- (RACSignal *)fetchOrdersWithOrderIDs:(NSSet<NSString *> *)orderIDs symbol:(NSString *)symbol finished:(BOOL)finished;{
    NSParameterAssert(orderIDs.count && orderIDs.count <= 50);
    NSParameterAssert(symbol.length);
    
    NSString *orderIDsString = [[orderIDs allObjects] componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"order_id": orderIDsString, @"symbol": ntoe(symbol), @"type": @(finished)};
    
    return [self POST:@"/api/v1/orders_info.do" parameters:parameters resultClass:[EXOrder class] keyPath:@"orders"];
}

- (RACSignal *)fetchHistoryOrdersWithSymbol:(NSString *)symbol finished:(BOOL)finished page:(NSUInteger)page size:(NSUInteger)size;{
    NSParameterAssert(symbol.length);
    
    size = MIN(200, size);
    NSDictionary *parameters = @{@"symbol": ntoe(symbol), @"status": @(finished), @"current_page": @(page), @"page_length": @(size)};
    
    return [self POST:@"/api/v1/order_history.do" parameters:parameters resultClass:[EXOrder class] keyPath:@"orders"];
}

@end
