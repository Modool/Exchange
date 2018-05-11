//
//  EXDelegatesAccessor.h
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDMulticastDelegate/MDMulticastDelegate.h>
#import <MDQueueObject/MDQueueObject.h>

@protocol EXDelegatesAccessor <NSObject>

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate;

@end

@interface EXDelegatesAccessor : MDQueueObject<EXDelegatesAccessor> {
@private
    MDMulticastDelegate *_delegates;
}

@property (nonatomic, strong, readonly) MDMulticastDelegate *delegates;

+ (void)async:(void (^)(id accessor))block;
+ (void)sync:(void (^)(id accessor))block;

- (void)registerDelegateForAcceessor:(Class)class;
- (void)deregisterDelegateForAcceessor:(Class)class;

@end
