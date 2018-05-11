//
//  EXKLineMetadata.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXKLineMetadata.h"

@interface EXKLineMetadata ()

@property (nonatomic, assign) double open;

@property (nonatomic, assign) double close;

@property (nonatomic, assign) double highest;

@property (nonatomic, assign) double lowest;

@property (nonatomic, assign) double volume;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXKLineMetadata

+ (instancetype)dataWithOpen:(double)open close:(double)close highest:(double)highest lowest:(double)lowest volume:(double)volume time:(NSTimeInterval)time;{
    return [[self alloc] initWithOpen:open close:close highest:highest lowest:lowest volume:volume time:time];
}

- (instancetype)initWithOpen:(double)open close:(double)close highest:(double)highest lowest:(double)lowest volume:(double)volume time:(NSTimeInterval)time;{
    if (self = [super init]) {
        _open = open;
        _close = close;
        _highest = highest;
        _lowest = lowest;
        _volume = volume;
        _time = time;
    }
    return self;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXKLineMetadata *metadata;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(metadata, open): @"open",
               @keypath(metadata, close): @"close",
               @keypath(metadata, highest): @"highest",
               @keypath(metadata, lowest): @"lowest",
               @keypath(metadata, volume): @"volume",
               @keypath(metadata, time): @"time",
               }];
}

+ (NSArray<NSString *> *)sortedKeys{
    EXKLineMetadata *metadata;
    return @[@keypath(metadata, time),
              @keypath(metadata, open),
              @keypath(metadata, highest),
              @keypath(metadata, lowest),
              @keypath(metadata, close),
              @keypath(metadata, volume)];
}

@end
