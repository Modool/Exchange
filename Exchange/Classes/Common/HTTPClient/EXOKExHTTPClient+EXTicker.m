
//
//  EXOKExHTTPClient+EXTicker.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXTicker.h"
#import "EXTicker.h"

@implementation EXOKExHTTPClient (EXTicker)

- (RACSignal *)fetchTickerWithSymbol:(NSString *)symbol;{
    return [self GET:@"/api/v1/ticker.do" parameters:@{@"symbol": ntoe(symbol)} resultClass:[EXTicker class] keyPath:@"ticker"];
}

@end
