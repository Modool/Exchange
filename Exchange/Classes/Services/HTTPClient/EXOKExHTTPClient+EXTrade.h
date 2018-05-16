//
//  EXOKExHTTPClient+EXTrade.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"
#import "EXConstants.h"

@interface EXOKExHTTPClient (EXTrade)<EXHTTPClientTrade>

// result: list of EXTrade
- (RACSignal *)fetchTradesWithSymbol:(NSString *)symbol since:(NSTimeInterval)since;

// result: order id
- (RACSignal *)tradeWithSymbol:(NSString *)symbol type:(EXTradeType)type price:(double)price amount:(double)amount;

// result: list of order id
- (RACSignal *)batchTradeWithSymbol:(NSString *)symbol block:(void (^)(EXTradeType *type, double *price, double *amount, BOOL *stop))block;

@end
