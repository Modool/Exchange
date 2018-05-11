//
//  NSIndexSet+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/21.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "NSIndexSet+EXAdditions.h"

const NSInteger NSIndexSetArgumentsEnd = NSIntegerMin;

@implementation NSIndexSet (EXAdditions)

+ (instancetype)indexSetWithIndexes:(NSUInteger)first, ...{
    va_list v;
    va_start(v, first);
    
    NSInteger index = first;
    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:first];
    while (index != NSIndexSetArgumentsEnd) {
        [set addIndex:index];
        
        index = va_arg(v, NSInteger);
    }
    
    va_end(v);
    
    return [set copy];
}

- (NSSet *)numberSet;{
    NSMutableSet *set = [NSMutableSet set];
    [self enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [set addObject:@(index)];
    }];
    
    return [set copy];
}

- (NSArray *)numberArray;{
    return [[self numberSet] allObjects];
}

@end
