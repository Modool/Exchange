//
//  EXOKExHTTPClient+EXTicker.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"

@interface EXOKExHTTPClient (EXTicker)<EXHTTPClientTicker>

// result: EXTicker
- (RACSignal *)fetchTickerWithSymbol:(NSString *)symbol;

@end
