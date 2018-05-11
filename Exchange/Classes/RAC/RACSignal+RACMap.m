//
//  RACSignal+RACMap.m
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACSignal+RACMap.h"

@implementation RACSignal (RACMap)

- (instancetype)mapWithTarget:(id)target performSelector:(SEL)selector;{
    @weakify(target);
    return [[self map:^id(id value) {
        @strongify(target);
        NSParameterAssert([target respondsToSelector:selector]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:selector withObject:value];
#pragma clang diagnostic pop
    }] setNameWithFormat:@"[%@] -mapWithTarget:performSelector:", [self name]];
}

- (instancetype)mapPerformSelector:(SEL)selector;{
    return [[self mapPerformSelector:selector withObject:nil] setNameWithFormat:@"[%@] -mapPerformSelector:", [self name]];
}

- (instancetype)mapPerformSelector:(SEL)selector withObject:(id)object;{
    return [[self map:^id(id value) {
        NSParameterAssert(!value || [value respondsToSelector:selector]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [value performSelector:selector withObject:object];
#pragma clang diagnostic pop
    }] setNameWithFormat:@"[%@] -mapPerformSelector:withObject:", [self name]];
}

- (instancetype)mapSwitch:(NSDictionary *)cases;{
    return [[self mapSwitch:cases defaultValue:nil] setNameWithFormat:@"[%@] -mapSwitch:", [self name]];
}

- (instancetype)mapSwitch:(NSDictionary *)cases defaultValue:(id)defaultValue;{
    return [[self map:^id(id innerValue) {
        if (!innerValue) return nil;
        
        id value = cases[innerValue];
        if (value) return value;
        
        return defaultValue;
    }] setNameWithFormat:@"[%@] -mapSwitch:defaultValue:", [self name]];
}

- (instancetype)mapIn:(NSArray *)values;{
    return [[self map:^id(id value) {
        return @([values containsObject:value]);
    }] setNameWithFormat:@"[%@] -mapIn:", [self name]];
}

- (instancetype)mapByteAnd:(NSUInteger)value;{
    return [[self map:^id(id innerValue) {
        return @([innerValue unsignedIntegerValue] & value);
    }] setNameWithFormat:@"[%@] -mapIn:", [self name]];
}

- (instancetype)mapByteOr:(NSUInteger)value;{
    return [[self map:^id(id innerValue) {
        return @([innerValue unsignedIntegerValue] | value);
    }] setNameWithFormat:@"[%@] -mapIn:", [self name]];
}

- (instancetype)mapEqual:(id)value replacement:(id)replacement{
    return [[self mapEqual:value replacement:replacement elsewise:nil] setNameWithFormat:@"[%@] -mapEqual:replacement:", [self name]];
}

- (instancetype)mapEqual:(id)value replacement:(id)replacement elsewise:(id)elsewise;{
    return [[self map:^id(id innerValue) {
        return (innerValue == value || [innerValue isEqual:value]) ? replacement : elsewise;
    }] setNameWithFormat:@"[%@] -mapEqual:replacement:elsewise:", [self name]];
}

- (instancetype)mapSelectTruth:(id)truth;{
    return [[self mapSelectTruth:truth fallacy:nil] setNameWithFormat:@"[%@] -mapSelectTruth:", [self name]];
}

- (instancetype)mapSelectFallacy:(id)fallacy;{
    return [[self mapSelectTruth:nil fallacy:fallacy] setNameWithFormat:@"[%@] -mapSelectFallacy:", [self name]];
}

- (instancetype)mapSelectTruth:(id)truth fallacy:(id)fallacy;{
    return [[self map:^id(id value) {
        if (!value) return nil;
        if (![value isKindOfClass:[NSNumber class]]) return nil;
        
        return [value boolValue] ? truth : fallacy;
    }] setNameWithFormat:@"[%@] -mapSelectTruth:fallacy:", [self name]];
}

- (instancetype)mapNull:(id)null;{
    return [[self mapNull:null nonull:nil] setNameWithFormat:@"[%@] -mapNull:", [self name]];
}

- (instancetype)mapNonull:(id)nonull;{
    return [[self mapNull:nil nonull:nonull] setNameWithFormat:@"[%@] -mapNonull:", [self name]];
}

- (instancetype)mapNull:(id)null nonull:(id)nonull;{
    return [[self map:^id(id value) {
        return value ? nonull : null;
    }] setNameWithFormat:@"[%@] -mapNull:nonull:", [self name]];
}

- (instancetype)mapArrayCount{
    return [[self map:^id _Nullable(id  _Nullable value) {
        NSParameterAssert(!value || [value isKindOfClass:[NSArray class]]);
        
        return @([value ?: @[] count]);
    }] setNameWithFormat:@"[%@] -mapArrayCount", [self name]];
}

- (instancetype)mapStringLength;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        NSParameterAssert(!value || [value isKindOfClass:[NSString class]]);
        
        return @([value length]);
    }] setNameWithFormat:@"[%@] -mapStringLength", [self name]];
}

- (instancetype)mapStringValue;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        return [value description];
    }] setNameWithFormat:@"[%@] -mapStringValue", [self name]];
}

- (instancetype)mapIntegerValue;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(integerValue)]);
        
        return @([value integerValue]);
    }] setNameWithFormat:@"[%@] -mapIntegerValue", [self name]];
}

- (instancetype)mapBooleanValue;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        NSParameterAssert(!value || [value respondsToSelector:@selector(boolValue)]);
        
        return @([value boolValue]);
    }] setNameWithFormat:@"[%@] -mapBooleanValue", [self name]];
}

- (instancetype)mapGreater:(NSInteger)value;{
    return [[self map:^id(id innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:@selector(integerValue)]);
        
        return @([innerValue integerValue] > value);
    }] setNameWithFormat:@"[%@] -mapGreater:", [self name]];
}

- (instancetype)mapLess:(NSInteger)value;{
    return [[self map:^id(id innerValue) {
        NSParameterAssert(!innerValue || [innerValue respondsToSelector:@selector(integerValue)]);
        
        return @([innerValue integerValue] < value);
    }] setNameWithFormat:@"[%@] -mapLess:", [self name]];
}

- (instancetype)mapGreaterZero;{
    return [[self mapGreater:0] setNameWithFormat:@"[%@] -mapGreaterZero", [self name]];
}

- (instancetype)mapLessZero;{
    return [[self mapLess:0] setNameWithFormat:@"[%@] -mapLessZero", [self name]];
}

- (instancetype)mapEqual:(id)value;{
    return [[self map:^id _Nullable(id  _Nullable innerValue) {
        return @(innerValue == value || [innerValue isEqual:value]);
    }] setNameWithFormat:@"[%@] -mapEqual:", [self name]];
}

- (instancetype)mapEqualNil;{
    return [[self mapEqual:nil] setNameWithFormat:@"[%@] -mapEqualNil", [self name]];
}

- (instancetype)mapForKeypath:(NSString *)keypath;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        return [value valueForKeyPath:keypath];
    }] setNameWithFormat:@"[%@] -mapForKeypath:", [self name]];
}

- (instancetype)mapForKey:(NSString *)key;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        return [value valueForKey:key];
    }] setNameWithFormat:@"[%@] -mapForKey:", [self name]];
}

- (instancetype)mapKeypaths:(NSArray<NSString *> *)keypaths;{
    return [[self map:^id _Nullable(id  _Nullable value) {
        NSMutableArray *values = [NSMutableArray new];
        for (NSString *keypath in keypaths) {
            [values addObject:[value valueForKeyPath:keypath] ?: [NSNull null]];
        }
        return [RACTuple tupleWithObjectsFromArray:values];
    }] setNameWithFormat:@"[%@] -mapForKeypath:", [self name]];
}

@end
