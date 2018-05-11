//
//  EXDelegatesAccessor.m
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"
#import "EXDelegatesAccessor+Private.h"
#import "EXDelegatesAccessor+EXAccessors.h"

@interface EXDelegatesAccessor ()<EXDelegatesAccessor>

@property (nonatomic, strong) MDMulticastDelegate *delegates;

@end

@implementation EXDelegatesAccessor

+ (instancetype)sharedAccessor;{
    return [self accessorForClass:[self class]];
}

- (instancetype)init{
    if (self = [super init]) {
        self.delegates = [MDMulticastDelegate new];
    }
    return self;
}

#pragma mark  - public

+ (void)async:(void (^)(id accessor))block;{
    __weak EXDelegatesAccessor *accessor = [self sharedAccessor];
    [accessor async:^{
        block(accessor);
    }];
}

+ (void)sync:(void (^)(id accessor))block;{
    __weak EXDelegatesAccessor *accessor = [self sharedAccessor];
    [accessor sync:^{
        block(accessor);
    }];
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;{
    [[self delegates] removeDelegate:delegate delegateQueue:delegateQueue];
    [[self delegates] addDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;{
    [[self delegates] removeDelegate:delegate delegateQueue:delegateQueue];
}

- (void)removeDelegate:(id)delegate;{
    [[self delegates] removeDelegate:delegate];
}

- (void)registerDelegateForAcceessor:(Class)class{
    [class sync:^(EXDelegatesAccessor *accessor) {
        [accessor addDelegate:self delegateQueue:[self queue]];
    }];
}

- (void)deregisterDelegateForAcceessor:(Class)class{
    [class sync:^(EXDelegatesAccessor *accessor) {
        [accessor removeDelegate:self delegateQueue:[self queue]];
    }];
}

@end
