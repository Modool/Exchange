//
//  EXDelegatesAccessor+EXAccessors.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@interface EXDelegatesAccessor (EXAccessors)

+ (NSArray<EXDelegatesAccessor> *)sharedAccessors;

+ (id)accessorForClass:(Class<EXDelegatesAccessor>)class;

+ (void)addAccessor:(id<EXDelegatesAccessor>)accessor;
+ (void)removeAccessor:(id<EXDelegatesAccessor>)accessor;

@end
