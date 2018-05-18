//
//  EXDelegatesAccessor+EXAccessors.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor+EXAccessors.h"

@implementation EXDelegatesAccessor (EXAccessors)

+ (NSRecursiveLock *)accessorLock;{
    static NSRecursiveLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSRecursiveLock alloc] init];
    });
    return lock;
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
    [self.accessorLock lock];
    NSArray<EXDelegatesAccessor> *accessors = [[self accessors] copy];
    [self.accessorLock unlock];
    return accessors;
}

+ (id)accessorForClass:(Class<EXDelegatesAccessor>)class;{
    [self.accessorLock lock];
    id<EXDelegatesAccessor> accessor = [self _accessorForClass:class];
    [self.accessorLock unlock];
    return accessor;
}

+ (void)addAccessor:(id<EXDelegatesAccessor>)accessor;{
    [self.accessorLock lock];
    [self _addAccessor:accessor];
    [self.accessorLock unlock];
}

+ (void)removeAccessor:(id<EXDelegatesAccessor>)accessor;{
    [self.accessorLock lock];
    [self _removeAccessor:accessor];
    [self.accessorLock unlock];
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
