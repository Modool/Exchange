//
//  RACSignal+RACReduce.h
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (RACReduce)

- (instancetype)reduceTake:(NSUInteger)take;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToValue:(id)value;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toValue:(id)value;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath equal:(BOOL)equal toValue:(id)value;

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToTake:(NSUInteger)take3;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toTake:(NSUInteger)take3;

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath equal:(BOOL)equal toTake:(NSUInteger)take3;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toTake:(NSUInteger)take3 valueForKeypath:(NSString *)keypath;
- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath1 equal:(BOOL)equal toTake:(NSUInteger)take3 valueForKeypath:(NSString *)keypath2;

- (instancetype)reduceTakeAnyNonull;
- (instancetype)reduceTakeAnyNull;

@end
