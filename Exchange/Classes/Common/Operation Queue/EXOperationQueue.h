//
//  EXOperationQueue.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>
#import "EXMacros.h"
#import "EXOperation.h"

@interface EXOperationQueue : MDQueueObject

@property (nonatomic, strong, readonly) dispatch_queue_t queue EX_UNAVAILABLE;

@property (nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

@property (nonatomic, assign, readonly, getter=isCanceled) BOOL canceled;

@property (nonatomic, copy, readonly) NSArray<EXOperation *> *operations;

// Default is NSUIntegerMax
@property (nonatomic, assign) NSUInteger maximumConcurrentCount;

@property (nonatomic, copy) void (^completion)(EXOperationQueue *queue, BOOL success);

+ (instancetype)queue;
+ (instancetype)queueWithOperations:(NSArray<EXOperation *> *)operations;

- (instancetype)initWithOperations:(NSArray<EXOperation *> *)operations;

- (void)async:(dispatch_block_t)block EX_UNAVAILABLE;
- (void)sync:(dispatch_block_t)block EX_UNAVAILABLE;

- (void)addOperation:(EXOperation *)operation;
- (void)addOperations:(NSArray<EXOperation *> *)operations;

- (void)schedule;
- (void)cancel;

- (long)wait:(dispatch_time_t)timeout;
- (long)waitUntilFinished;

@end
