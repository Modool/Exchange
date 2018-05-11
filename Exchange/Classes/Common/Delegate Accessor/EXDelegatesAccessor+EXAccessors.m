//
//  EXDelegatesAccessor+EXAccessors.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor+EXAccessors.h"

@implementation EXDelegatesAccessor (EXAccessors)

+ (dispatch_queue_t)accessorQueue;{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.markejave.link.accessors.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

+ (NSMutableArray *)accessors{
    static NSMutableArray<EXDelegatesAccessor> *accessors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accessors = [NSMutableArray<EXDelegatesAccessor> new];
    });
    return accessors;
}

#pragma mark - public

+ (NSArray<EXDelegatesAccessor> *)sharedAccessors;{
    __block NSArray<EXDelegatesAccessor> *accessors = nil;
    
    dispatch_sync([self accessorQueue], ^{
        accessors = [[self accessors] copy];
    });
    
    return accessors;
}

+ (id)accessorForClass:(Class<EXDelegatesAccessor>)class;{
    __block id<EXDelegatesAccessor> accessor = nil;
    
    dispatch_sync([self accessorQueue], ^{
        accessor = [self _accessorForClass:class];
    });
    
    return accessor;
}

+ (void)addAccessor:(id<EXDelegatesAccessor>)accessor;{
    dispatch_sync([self accessorQueue], ^{
        [self _addAccessor:accessor];
    });
}

+ (void)removeAccessor:(id<EXDelegatesAccessor>)accessor;{
    dispatch_sync([self accessorQueue], ^{
        [self _removeAccessor:accessor];
    });
}

#pragma mark - private

+ (id)_accessorForClass:(Class<EXDelegatesAccessor>)class;{
    NSParameterAssertReturnNil(class != [EXDelegatesAccessor class]);
    NSParameterAssertReturnNil([[class class] isSubclassOfClass:[EXDelegatesAccessor class]]);
    
    for (id<EXDelegatesAccessor> accessor in [self accessors]) {
        if ([accessor isKindOfClass:class]) return accessor;
        if ([[accessor class] isSubclassOfClass:class]) return accessor;
    }
    
    return nil;
}

+ (void)_addAccessor:(id<EXDelegatesAccessor>)accessor;{
    NSParameterAssertReturnVoid([accessor class] != [EXDelegatesAccessor class]);
    NSParameterAssertReturnVoid([[accessor class] isSubclassOfClass:[EXDelegatesAccessor class]]);
    
    [[self accessors] addObject:accessor];
}

+ (void)_removeAccessor:(id<EXDelegatesAccessor>)accessor;{
    [[self accessors] removeObject:accessor];
}

@end
