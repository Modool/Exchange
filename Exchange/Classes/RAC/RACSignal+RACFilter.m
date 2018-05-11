//
//  RACSignal+RACFilter.m
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACSignal+RACFilter.h"

RACSignal *RACSignalFilter(Class class, BOOL positive, id value) {
    if (positive) {
        return [class return:value];
    } else {
        return [class empty];
    }
}

@implementation RACSignal (RACFilter)

- (instancetype)equal:(id)value;{
    return [[self map:^id(id innerValue) {
        return @(innerValue == value || [innerValue isEqual:value]);
    }] setNameWithFormat:@"[%@] -equal:", [self name]];
}

- (instancetype)filterTrueTake:(NSUInteger)take;{
    NSParameterAssert(take);
    return [self filterTake:take truth:YES];
}

- (instancetype)filterFalseTake:(NSUInteger)take;{
    NSParameterAssert(take);
    return [self filterTake:take truth:NO];
}

- (instancetype)filterTake:(NSUInteger)take truth:(BOOL)truth;{
    NSParameterAssert(take);
    NSUInteger takeIndex = (take - 1);
    return [[self filter:^BOOL(RACTuple *tuple) {
        id takeValue = [tuple objectAtIndex:takeIndex];
        NSParameterAssert(!takeValue || [takeValue respondsToSelector:@selector(boolValue)]);
        
        return (truth == [takeValue boolValue]);
    }] setNameWithFormat:@"[%@] -filterTake:equal:value:", [self name]];
}

- (instancetype)filterTake:(NSUInteger)take equal:(BOOL)equal toValue:(id)value;{
    NSParameterAssert(take);
    NSUInteger takeIndex = (take - 1);
    return [[self filter:^BOOL(RACTuple *tuple) {
        id takeValue = [tuple objectAtIndex:takeIndex];
        
        return (equal == [takeValue isEqual:value]);
    }] setNameWithFormat:@"[%@] -filterTake:equal:value:", [self name]];
}

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2;{
    return [self filterTake:take1 if:take2 truth:YES];
}

- (instancetype)filterTake:(NSUInteger)take1 ifNot:(NSUInteger)take2;{
    return [self filterTake:take1 if:take2 truth:NO];
}

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 truth:(BOOL)truth;{
    NSParameterAssert(take1 && take2);
    NSUInteger takeIndex1 = (take1 - 1);
    NSUInteger takeIndex2 = (take2 - 1);
    return [[[self filter:^BOOL(RACTuple *tuple) {
        return (truth == [[tuple objectAtIndex:takeIndex2] boolValue]);
    }] map:^id(RACTuple *tuple) {
        return [tuple objectAtIndex:takeIndex1];
    }] setNameWithFormat:@"[%@] -filterTake:if:", [self name]];
}

- (instancetype)filterIf:(NSUInteger)take equalToValue:(id)value;{
    return [self filterIf:take equal:YES toValue:value];
}

- (instancetype)filterIf:(NSUInteger)take equal:(BOOL)equal toValue:(id)value;{
    NSParameterAssert(take);
    NSUInteger takeIndex = (take - 1);
    return [[self filter:^BOOL(RACTuple *tuple) {
        return (equal == [[tuple objectAtIndex:takeIndex] isEqual:value]);
    }] setNameWithFormat:@"[%@] -filterIf:equal:toValue:", [self name]];
}

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToValue:(id)value;{
    return [self filterTake:take1 if:take2 equal:YES toValue:value];
}

- (instancetype)filterTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toValue:(id)value;{
    NSParameterAssert(take1 && take2);
    NSUInteger takeIndex1 = (take1 - 1);
    NSUInteger takeIndex2 = (take2 - 1);
    return [[[self filter:^BOOL(RACTuple *tuple) {
        return (equal == [[tuple objectAtIndex:takeIndex2] isEqual:value]);
    }] map:^id(RACTuple *tuple) {
        return [tuple objectAtIndex:takeIndex1];
    }] setNameWithFormat:@"[%@] -filterTake:if:equal:toValue:", [self name]];
}

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTrueTake:(NSUInteger)take;{
    return [[self combineLatest:signals] filterTrueTake:take];
}

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterFalseTake:(NSUInteger)take;{
    return [[self combineLatest:signals] filterFalseTake:take];
}

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTake:(NSUInteger)take1 if:(NSUInteger)take2;{
    return [[self combineLatest:signals] filterTake:take1 if:take2];
}

+ (instancetype)combineLatest:(id<NSFastEnumeration>)signals filterTake:(NSUInteger)take1 ifNot:(NSUInteger)take2;{
    return [[self combineLatest:signals] filterTake:take1 ifNot:take2];
}

- (instancetype)filterValue:(id)value;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id innerValue) {
        return RACSignalFilter(class, (innerValue == value || [innerValue isEqual:value]), innerValue);
    }] setNameWithFormat:@"[%@] -filterWith:", [self name]];
}

- (instancetype)filterInValues:(NSArray *)values;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, [values containsObject:value], value);
    }] setNameWithFormat:@"[%@] -filterInValues:", [self name]];
}

- (instancetype)ignoreValue:(id)value;{
    return [[self ignore:value] setNameWithFormat:@"[%@] -filter:", [self name]];
}

- (instancetype)ignoreInValues:(NSArray *)values;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, ![values containsObject:value], value);
    }] setNameWithFormat:@"[%@] -filterInValues:", [self name]];
}

- (instancetype)filterClass:(Class)class;{
    Class _class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        BOOL positive = [value isKindOfClass:class];
        return RACSignalFilter(_class, positive, value);
    }] setNameWithFormat:@"[%@] -filterClass:", [self name]];
}

- (instancetype)ignoreClass:(Class)class;{
    Class _class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(_class, ![value isKindOfClass:class], value);
    }] setNameWithFormat:@"[%@] -ignoreClass:", [self name]];
}

- (instancetype)filterProtocol:(Protocol *)protocol;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, [value conformsToProtocol:protocol], value);
    }] setNameWithFormat:@"[%@] -filterProtocol:", [self name]];
}

- (instancetype)ignoreProtocol:(Protocol *)protocol;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, ![value conformsToProtocol:protocol], value);
    }] setNameWithFormat:@"[%@] -ignoreProtocol:", [self name]];
}

- (instancetype)filterRespondsSelector:(SEL)selector;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, [value respondsToSelector:selector], value);
    }] setNameWithFormat:@"[%@] -filterRespondsSelector:", [self name]];
}

- (instancetype)filterPerformSelector:(SEL)selector;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        NSParameterAssert(!value || [value respondsToSelector:selector]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL positive = [[value performSelector:selector] boolValue];
#pragma clang diagnostic pop
        return RACSignalFilter(class, positive, value);
    }] setNameWithFormat:@"[%@] -filterPerformSelector:", [self name]];
}

- (instancetype)filterForKeyPath:(NSString *)keypath;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        value = [value valueForKeyPath:keypath];
        BOOL positive = [value respondsToSelector:@selector(boolValue)] && [value boolValue];
        return RACSignalFilter(class, positive, value);
    }] setNameWithFormat:@"[%@] -filterForKeyPath:", [self name]];
}

- (instancetype)filter:(id)value keyPath:(NSString *)keypath;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, [value isEqual:[value valueForKeyPath:keypath]], value);
    }] setNameWithFormat:@"[%@] -filter:keyPath:", [self name]];
}

- (instancetype)filter:(id)value selector:(SEL)selector;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:selector]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL positive = [value isEqual:[innerValue performSelector:selector]];
#pragma clang diagnostic pop
        return RACSignalFilter(class, positive, value);
    }] setNameWithFormat:@"[%@] -filter:selector:", [self name]];
}

- (instancetype)ignore:(id)value keyPath:(NSString *)keypath;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id value) {
        return RACSignalFilter(class, ![value isEqual:[value valueForKeyPath:keypath]], value);
    }] setNameWithFormat:@"[%@] -filter:keyPath:", [self name]];
}

- (instancetype)ignore:(id)value selector:(SEL)selector;{
    Class class = [self class];
    
    return [[self flattenMap:^ id (id innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:selector]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL positive = ![value isEqual:[innerValue performSelector:selector]];
#pragma clang diagnostic pop
        return RACSignalFilter(class, positive, value);
    }] setNameWithFormat:@"[%@] -filter:selector:", [self name]];
}

- (instancetype)filterGreater:(NSUInteger)value;{
    return [[self filter:^BOOL(id  _Nullable innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:@selector(integerValue)]);
        return [innerValue integerValue] > value;
    }] setNameWithFormat:@"[%@] -filterGreater:", [self name]];
}

- (instancetype)filterGreaterZero;{
    return [[self filterGreater:0] setNameWithFormat:@"[%@] -filterArrayCountGreaterZero", [self name]];
}

- (instancetype)filterLess:(NSUInteger)value;{
    return [[self filter:^BOOL(id  _Nullable innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:@selector(integerValue)]);
        return [innerValue integerValue] < value;
    }] setNameWithFormat:@"[%@] -filterLess:", [self name]];
}
- (instancetype)filterLessZero;{
    return [[self filterLess:0] setNameWithFormat:@"[%@] -filterLessZero", [self name]];
}

- (instancetype)filterEqualNil;{
    return [[self filterValue:nil] setNameWithFormat:@"[%@] -filterEqualNil", [self name]];
}

- (instancetype)filterNotEqualNil;{
    return [[self ignore:nil] setNameWithFormat:@"[%@] -filterNotEqualNil", [self name]];
}

- (instancetype)filterBooleanPositive;{
    return [[self filter:^BOOL(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(boolValue)]);
        return [value boolValue];
    }] setNameWithFormat:@"[%@] -filterBooleanPositive", [self name]];
}

- (instancetype)filterBooleanNegation;{
    return [[self filter:^BOOL(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(boolValue)]);
        return ![value boolValue];
    }] setNameWithFormat:@"[%@] -filterBooleanNegation", [self name]];
}

- (instancetype)filterArrayCountGreater:(NSUInteger)count;{
    return [[self filter:^BOOL(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(count)]);
        return [value count] > count;
    }] setNameWithFormat:@"[%@] -filterArrayCountGreater:", [self name]];
}

- (instancetype)filterArrayCountGreaterZero;{
    return [[self filterArrayCountGreater:0] setNameWithFormat:@"[%@] -filterArrayCountGreaterZero", [self name]];
}

- (instancetype)filterArrayCountLess:(NSUInteger)count;{
    return [[self filter:^BOOL(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(count)]);
        return [value count] < count;
    }] setNameWithFormat:@"[%@] -filterArrayCountLess:", [self name]];
}
- (instancetype)filterArrayCountLessZero;{
    return [[self filterArrayCountLess:0] setNameWithFormat:@"[%@] -filterArrayCountLessZero", [self name]];
}

- (instancetype)filterArrayCountEqual:(NSUInteger)count;{
    return [[self filter:^BOOL(id  _Nullable value) {
        NSParameterAssert(!value ||[value respondsToSelector:@selector(count)]);
        return [value count] == count;
    }] setNameWithFormat:@"[%@] -filterArrayCountEqual:", [self name]];
}

@end
