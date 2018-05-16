//
//  EXKLineMetadata.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@interface EXKLineMetadata : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, assign, readonly) double open;

@property (nonatomic, assign, readonly) double close;

@property (nonatomic, assign, readonly) double highest;

@property (nonatomic, assign, readonly) double lowest;

@property (nonatomic, assign, readonly) double volume;

@property (nonatomic, assign, readonly) NSTimeInterval time;

@property (nonatomic, copy, class, readonly) NSArray<NSString *> *sortedKeys;

+ (instancetype)dataWithOpen:(double)open close:(double)close highest:(double)highest lowest:(double)lowest volume:(double)volume time:(NSTimeInterval)time symbol:(NSString *)symbol domain:(NSString *)domain;
- (instancetype)initWithOpen:(double)open close:(double)close highest:(double)highest lowest:(double)lowest volume:(double)volume time:(NSTimeInterval)time symbol:(NSString *)symbol domain:(NSString *)domain;

@end
