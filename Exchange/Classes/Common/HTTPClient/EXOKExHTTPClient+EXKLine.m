
//
//  EXOKExHTTPClient+EXKLine.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXKLine.h"
#import "EXKLineMetadata.h"

@implementation EXOKExHTTPClient (EXKLine)

- (RACSignal *)fetchKLinesWithSymbol:(NSString *)symbol type:(EXKLineTimeRangeType)type size:(NSUInteger)size since:(NSTimeInterval)since;{
    EXKLineTimeRangeTypeString typeString = EXKLineTimeRangeTypeStringFromType(type);
    NSDictionary *parameters = @{@"symbol": ntoe(symbol), @"type": ntoe(typeString), @"size":@(size), @"since": @(since)};
    
    return [self GET:@"/api/v1/kline.do" parameters:parameters resultClass:[EXKLineMetadata class] keyPath:nil];
}

@end
