//
//  MDDConditionSet+EXAdditions.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDObjectDatabase/MDObjectDatabase.h>

#define MDDConditionSet6(CONDITION, ...)                    [MDDConditionSet setWithMultipleConditions:CONDITION, __VA_ARGS__]
#define MDDConditionSet7(OPERATION, CONDITION, ...)         [MDDConditionSet setWithOperation:OPERATION conditions:CONDITION, __VA_ARGS__]
#define MDDConditionSet8(OPERATION, SETS, CONDITION, ...)   [MDDConditionSet setWithOperation:OPERATION sets:SETS conditions:CONDITION, __VA_ARGS__]

@interface MDDConditionSet (EXAdditions)

+ (instancetype)setWithMultipleConditions:(MDDCondition *)condition, ...;
+ (instancetype)setWithOperation:(MDDConditionOperation)operation conditions:(MDDCondition *)condition, ...;
+ (instancetype)setWithOperation:(MDDConditionOperation)operation sets:(NSArray<MDDConditionSet *> *)sets conditions:(MDDCondition *)condition, ...;

@end
