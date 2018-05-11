//
//  RACSignal+RACMap.h
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (RACMap)

- (instancetype)mapWithTarget:(id)target performSelector:(SEL)selector;

- (instancetype)mapPerformSelector:(SEL)selector;
- (instancetype)mapPerformSelector:(SEL)selector withObject:(id)object;

- (instancetype)mapSwitch:(NSDictionary *)cases;
- (instancetype)mapSwitch:(NSDictionary *)cases defaultValue:(id)defaultValue;

- (instancetype)mapIn:(NSArray *)values;
- (instancetype)mapByteAnd:(NSUInteger)value;
- (instancetype)mapByteOr:(NSUInteger)value;

- (instancetype)mapEqual:(id)value replacement:(id)replacement;
- (instancetype)mapEqual:(id)value replacement:(id)replacement elsewise:(id)elsewise;

- (instancetype)mapSelectTruth:(id)truth;
- (instancetype)mapSelectFallacy:(id)fallacy;
- (instancetype)mapSelectTruth:(id)truth fallacy:(id)fallacy;

- (instancetype)mapNull:(id)null;
- (instancetype)mapNonull:(id)nonull;
- (instancetype)mapNull:(id)null nonull:(id)nonull;

- (instancetype)mapArrayCount;
- (instancetype)mapStringLength;

- (instancetype)mapStringValue;
- (instancetype)mapIntegerValue;
- (instancetype)mapBooleanValue;

- (instancetype)mapGreater:(NSInteger)value;
- (instancetype)mapLess:(NSInteger)value;

- (instancetype)mapGreaterZero;
- (instancetype)mapLessZero;

- (instancetype)mapEqual:(id)value;
- (instancetype)mapEqualNil;

- (instancetype)mapForKeypath:(NSString *)keypath;
- (instancetype)mapForKey:(NSString *)key;

- (instancetype)mapKeypaths:(NSArray<NSString *> *)keypaths;

@end
