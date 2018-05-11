//
//  NSIndexSet+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/21.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

EX_EXTERN const NSInteger NSIndexSetArgumentsEnd;

@interface NSIndexSet (EXAdditions)

+ (instancetype)indexSetWithIndexes:(NSUInteger)first, ...;

- (NSSet *)numberSet;

- (NSArray *)numberArray;

@end
