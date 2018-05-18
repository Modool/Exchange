//
//  EXOperationQueue.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXMacros.h"
#import "EXOperation.h"

@interface EXOperationQueue : NSObject

@property (copy, readonly) NSArray<EXOperation *> *operations;

@property (strong, readonly) dispatch_queue_t queue;

@property (assign, readonly, getter=isExecuting) BOOL executing;

@property (assign, readonly, getter=isCanceled) BOOL canceled;

// Default is NSUIntegerMax
@property (assign) NSUInteger maximumConcurrentCount;

@property (copy) void (^completion)(EXOperationQueue *queue, BOOL success);

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
