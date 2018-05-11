//
//  EXOKExHTTPClient+EXKLine.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"
#import "EXConstants.h"

@interface EXOKExHTTPClient (EXKLine)<EXHTTPClientKLine>

// result: list of EXKLineMetadata
- (RACSignal *)fetchKLinesWithSymbol:(NSString *)symbol type:(EXKLineTimeRangeType)type size:(NSUInteger)size since:(NSTimeInterval)since;

@end
