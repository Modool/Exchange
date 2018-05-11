//
//  EXOKExHTTPClient+EXDepth.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"

@interface EXOKExHTTPClient (EXDepth)<EXHTTPClientDepth>

// result: EXDepth
- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol;

// result: EXDepth
- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol size:(NSUInteger /* 200 */)size;

@end
