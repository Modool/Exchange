//
//  RACSignal+RACFilter.h
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (RACFilter)

- (instancetype)equal:(id)value;

- (instancetype)filterTrueTake:(NSUInteger)take;
- (instancetype)filterFalseTake:(NSUInteger)take;
- (instancetype)filterTake:(NSUInteger)take truth:(BOOL)truth;

- (instancetype)filterTake:(NSUInteger)take equal:(BOOL)equal toValue:(id)value;

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2;
- (instancetype)filterTake:(NSUInteger)take1 ifNot:(NSUInteger)take2;
- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 truth:(BOOL)truth;

- (instancetype)filterIf:(NSUInteger)take equalToValue:(id)value;
- (instancetype)filterIf:(NSUInteger)take equal:(BOOL)equal toValue:(id)value;

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToValue:(id)value;
- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toValue:(id)value;

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTrueTake:(NSUInteger)take;
+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterFalseTake:(NSUInteger)take;

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTake:(NSUInteger)take1 if:(NSUInteger)take2;
+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTake:(NSUInteger)take1 ifNot:(NSUInteger)take2;

- (instancetype)filterValue:(id)value;
- (instancetype)filterInValues:(NSArray *)values;

- (instancetype)ignoreValue:(id)value;
- (instancetype)ignoreInValues:(NSArray *)values;

- (instancetype)filterClass:(Class)class;
- (instancetype)ignoreClass:(Class)class;

- (instancetype)filterProtocol:(Protocol *)protocol;
- (instancetype)ignoreProtocol:(Protocol *)protocol;

- (instancetype)filterRespondsSelector:(SEL)selector;
- (instancetype)filterPerformSelector:(SEL)selector;

- (instancetype)filterForKeyPath:(NSString *)keypath;

- (instancetype)filter:(id)value keyPath:(NSString *)keypath;
- (instancetype)filter:(id)value selector:(SEL)selector;

- (instancetype)ignore:(id)value keyPath:(NSString *)keypath;
- (instancetype)ignore:(id)value selector:(SEL)selector;

- (instancetype)filterGreater:(NSUInteger)value;
- (instancetype)filterGreaterZero;

- (instancetype)filterLess:(NSUInteger)value;
- (instancetype)filterLessZero;

- (instancetype)filterEqualNil;
- (instancetype)filterNotEqualNil;

- (instancetype)filterBooleanPositive;
- (instancetype)filterBooleanNegation;

- (instancetype)filterArrayCountGreater:(NSUInteger)count;
- (instancetype)filterArrayCountGreaterZero;

- (instancetype)filterArrayCountLess:(NSUInteger)count;
- (instancetype)filterArrayCountLessZero;

- (instancetype)filterArrayCountEqual:(NSUInteger)count;

@end
