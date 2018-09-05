//
//  MDDConditionSet+EXAdditions.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDDConditionSet+EXAdditions.h"

@implementation MDDConditionSet (EXAdditions)

+ (instancetype)setWithMultipleConditions:(MDDCondition *)condition, ...;{
    va_list list, copiedList;
    va_start(list, condition);
    va_copy(copiedList, list);
    va_end(list);

    return [self setWithOperation:MDDConditionOperationAnd sets:nil condition:condition valist:copiedList];
}

+ (instancetype)setWithOperation:(MDDConditionOperation)operation conditions:(MDDCondition *)condition, ...;{
    va_list list, copiedList;
    va_start(list, condition);
    va_copy(copiedList, list);
    va_end(list);

    return [self setWithOperation:operation sets:nil condition:condition valist:copiedList];
}

+ (instancetype)setWithOperation:(MDDConditionOperation)operation sets:(NSArray<MDDConditionSet *> *)sets conditions:(MDDCondition *)condition, ...;{
    va_list list, copiedList;
    va_start(list, condition);
    va_copy(copiedList, list);
    va_end(list);

    return [self setWithOperation:operation sets:sets condition:condition valist:copiedList];
}

+ (instancetype)setWithOperation:(MDDConditionOperation)operation sets:(NSArray<MDDConditionSet *> *)sets condition:(MDDCondition *)condition valist:(va_list)valist;{
    NSMutableArray *conditions = [NSMutableArray array];
    MDDCondition *con = condition;
    
    while (con) {
        [conditions addObject:con];
        con = va_arg(valist, MDDCondition *);
    }
    return [self setWithConditions:conditions];
}

@end
