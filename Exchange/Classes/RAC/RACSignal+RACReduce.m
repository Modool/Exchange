//
//  RACSignal+RACReduce.m
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACSignal+RACReduce.h"

@implementation RACSignal (RACReduce)

- (instancetype)reduceTake:(NSUInteger)take;{
    NSParameterAssert(take);
    NSUInteger takeIndex = (take - 1);
    
    return [[self map:^id(RACTuple *tuple) {
        return [tuple objectAtIndex:takeIndex];
    }] setNameWithFormat:@"[%@] -reduceTake:", [self name]];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToValue:(id)value;{
    return [self reduceTake:take1 if:take2 equal:YES toValue:value];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toValue:(id)value;{
    return [self reduceTake:take1 if:take2 valueForKeyPath:nil equal:equal toValue:value];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath equal:(BOOL)equal toValue:(id)value;{
    NSParameterAssert(take1 && take2);
    NSUInteger takeIndex1 = (take1 - 1);
    NSUInteger takeIndex2 = (take2 - 1);
    
    return [[self map:^id(RACTuple *tuple) {
        id value1 = [tuple objectAtIndex:takeIndex1];
        id value2 = [tuple objectAtIndex:takeIndex2];
        
        value2 = [keypath length] ? [value2 valueForKeyPath:keypath] : nil;
        
        return (equal == ([value2 isEqual:value] || ((value == [NSNull null] || !value) && (value2 == [NSNull null] || !value2)))) ? value1 : nil;
    }] setNameWithFormat:@"[%@] -reduceTake:if:equal:toValue:", [self name]];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equalToTake:(NSUInteger)take3; {
    return [self reduceTake:take1 if:take2 equal:YES toTake:take3];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toTake:(NSUInteger)take3;{
    return [self reduceTake:take1 if:take2 valueForKeyPath:nil equal:equal toTake:take3 valueForKeypath:nil];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath equal:(BOOL)equal toTake:(NSUInteger)take3;{
    return [self reduceTake:take1 if:take2 valueForKeyPath:keypath equal:equal toTake:take3 valueForKeypath:nil];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 equal:(BOOL)equal toTake:(NSUInteger)take3 valueForKeypath:(NSString *)keypath;{
    return [self reduceTake:take1 if:take2 valueForKeyPath:nil equal:equal toTake:take3 valueForKeypath:keypath];
}

- (instancetype)reduceTake:(NSUInteger)take1 if:(NSUInteger)take2 valueForKeyPath:(NSString *)keypath1 equal:(BOOL)equal toTake:(NSUInteger)take3 valueForKeypath:(NSString *)keypath2;{
    NSParameterAssert(take1 && take2 && take3);
    NSUInteger takeIndex1 = (take1 - 1);
    NSUInteger takeIndex2 = (take2 - 1);
    NSUInteger takeIndex3 = (take3 - 1);
    
    return [[self map:^id(RACTuple *tuple) {
        id value1 = [tuple objectAtIndex:takeIndex1];
        id value2 = [tuple objectAtIndex:takeIndex2];
        id value3 = [tuple objectAtIndex:takeIndex3];
        
        value2 = [keypath1 length] ? [value2 valueForKeyPath:keypath1] : value2;
        value3 = [keypath2 length] ? [value3 valueForKeyPath:keypath2] : value3;
        ;
        return (equal == ([value2 isEqual:value3] || (value2 == [NSNull null] && value3 == [NSNull null] ))) ? value1 : nil;
    }] setNameWithFormat:@"[%@] -reduceTake:if:valueForKeyPath:equal:toTake:valueForKeypath:", [self name]];
}

- (instancetype)reduceTakeAnyNonull;{
    return [[self map:^id(RACTuple *tuple) {
        for (id value in [tuple allObjects]) {
            if (value && value != [NSNull null]) return value;
        }
        return nil;
    }] setNameWithFormat:@"[%@] -reduceTakeAnyNonull:", [self name]];
}

- (instancetype)reduceTakeAnyNull;{
    return [[self map:^id(RACTuple *tuple) {
        for (id value in [tuple allObjects]) {
            if (!value || value == [NSNull null]) return value;
        }
        return nil;
    }] setNameWithFormat:@"[%@] -reduceTakeAnyNull:", [self name]];
}

@end
