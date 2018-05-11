//
//  EXOKExHTTPClient+EXDepth.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXDepth.h"
#import "EXDepth.h"

@implementation EXOKExHTTPClient (EXDepth)

- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol;{
    return [self fetchDepthWithSymbol:symbol size:200];
}

- (RACSignal *)fetchDepthWithSymbol:(NSString *)symbol size:(NSUInteger /* 200 */)size;{
    size = MIN(200, size);
    size = MAX(1, size);
    
    return [self GET:@"/api/v1/depth.do" parameters:@{@"symbol": ntoe(symbol), @"size": @(size)} resultClass:[EXDepth class] keyPath:nil];
}

@end
