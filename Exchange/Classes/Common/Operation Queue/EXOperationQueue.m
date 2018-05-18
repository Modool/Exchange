//
//  EXOperationQueue.m
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperationQueue.h"
#import "EXOperationQueue+Private.h"
#import "EXOperation+Private.h"

NSString * const EXOperationQueueDomainPrefix = @"com.markejave.modool.operation.queue";

@implementation EXOperation (EXOperationQueue)

- (void)prepareInQueue:(EXOperationQueue *)queue;{}
- (void)completeInQueue:(EXOperationQueue *)queue;{}

@end

@implementation EXOperationQueue
@dynamic queue;

+ (instancetype)queue;{
    return [self queueWithOperations:nil];
}

+ (instancetype)queueWithOperations:(NSArray<EXOperation *> *)operations;{
    return [[self alloc] initWithOperations:operations];
}

- (instancetype)initWithOperations:(NSArray<EXOperation *> *)operations;{
    if (self = [super init]) {
        _lock = [[NSRecursiveLock alloc] init];
        _mutableOperations = [NSMutableArray arrayWithArray:operations ?: @[]];
        _excutingOperations = [NSMutableArray new];
        _maximumConcurrentCount = NSUIntegerMax;
        
        NSString *queueName = [MDQueueObjectDomainPrefix stringByAppendingFormat:@"%@#Concurrent#%lu", NSStringFromClass([self class]), (unsigned long)self];
        _queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _group = dispatch_group_create();
    }
    return self;
}

#pragma mark - accessor

- (NSArray<EXOperation *> *)operations{
    [_lock lock];
    NSArray<EXOperation *> *operations = [_mutableOperations copy];
    [_lock unlock];
    
    return operations;
}

- (NSUInteger)maximumConcurrentCount{
    [_lock lock];
    NSUInteger maximumConcurrentCount = _maximumConcurrentCount;
    [_lock unlock];
    
    return maximumConcurrentCount;
}

- (void)setMaximumConcurrentCount:(NSUInteger)maximumConcurrentCount{
    [_lock lock];
    _maximumConcurrentCount = maximumConcurrentCount;
    [_lock unlock];
}

- (BOOL)isExecuting{
    [_lock lock];
    BOOL executing = _executing;
    [_lock unlock];
    
    return executing;
}

- (BOOL)isCanceled{
    [_lock lock];
    BOOL canceled = self->_canceled;
    [_lock unlock];
    
    return canceled;
}

- (void)setCompletion:(void (^)(EXOperationQueue *, BOOL))completion{
    [_lock lock];
    _completion = [completion copy];
    [_lock unlock];
}

- (void (^)(EXOperationQueue *, BOOL))completion{
    [_lock lock];
    void (^completion)(EXOperationQueue *, BOOL) = [_completion copy];
    [_lock unlock];
    return completion;
}

- (dispatch_queue_t)queue{
    [_lock lock];
    dispatch_queue_t queue = _queue;
    [_lock unlock];
    return queue;
}

#pragma mark - public

- (void)addOperation:(EXOperation *)operation;{
    if (!operation) return;
    
    [self addOperations:@[operation]];
}

- (void)addOperations:(NSArray<EXOperation *> *)operations;{
    if (![operations count]) return;
    [_lock lock];
    [self _addOperations:operations];
    [_lock unlock];
}

- (void)schedule;{
    NSParameterAssertReturnVoid(![self isExecuting]);
    
    [_lock lock];
    [self _schedule];
    [_lock unlock];
}

- (void)cancel;{
    [_lock lock];
    [self _cancel];
    [_lock unlock];
}

- (long)wait:(dispatch_time_t)timeout;{
    if (isless(timeout, 0.0)) {
        timeout = DISPATCH_TIME_FOREVER;
    } else {
        timeout = dispatch_time(DISPATCH_TIME_NOW, (timeout * NSEC_PER_SEC));
    }
    
    return [self _wait:timeout];
}

- (long)waitUntilFinished;{
    return [self _wait:DISPATCH_TIME_FOREVER];
}

#pragma mark - private

- (void)_cancel{
    dispatch_suspend(_queue);
    
    for (EXOperation *operation in _mutableOperations) {
        [operation cancel];
    }
    
    for (EXOperation *operation in _excutingOperations) {
        [operation cancel];
    }
    
    [_mutableOperations removeAllObjects];
    
    _canceled = YES;
    
    dispatch_resume(_queue);
}

- (void)_addOperations:(NSArray<EXOperation *> *)operations;{
    dispatch_suspend(_queue);
    
    [_mutableOperations addObjectsFromArray:operations];
    
    if (_executing) [self _schedule];
    
    dispatch_resume(_queue);
}

- (void)_schedule{
    NSArray<EXOperation *> *operations = _mutableOperations.copy;
    if(![operations count]) return;
    
    NSUInteger count = MIN(_maximumConcurrentCount - [_excutingOperations count], [operations count]);
    if (!count) return;
    
    operations = [operations subarrayWithRange:NSMakeRange(0, count)];
    if(![operations count]) return;
    
    [_mutableOperations removeObjectsInArray:operations];
    
    _canceled = NO;
    [self _willBeginSchedule];
    [self _scheduleOperations:operations];
}

- (void)_scheduleOperations:(NSArray<EXOperation *> *)operations{
    if(![operations count]) return;
    
    [_excutingOperations addObjectsFromArray:operations];
    
    NSMutableArray<EXOperation *> *synchronousOperations = [NSMutableArray<EXOperation *> new];
    for (EXOperation *operation in operations) {
        if ([operation isFinished] || [operation isCancelled] || [operation isExecuting]) continue;
        
        if ([operation isConcurrent]) {
            [self _runOperation:operation];
        } else {
            [synchronousOperations addObject:operation];
        }
    }
    
    if ([synchronousOperations count]) {
        [self _runOperations:synchronousOperations];
    }
}

- (void)_runOperation:(EXOperation *)operation{
    if(!operation) return;
    
    [self _runOperations:@[operation]];
}

- (void)_runOperations:(NSArray<EXOperation *> *)operations{
    if(![operations count]) return;
    _executing = YES;
    
    dispatch_group_async(_group, _queue, ^{
        for (EXOperation *operation in operations) {
            [self _runMainWithOpeartion:operation];
            [self _completeWithOperation:operation];
        }
    });
}

- (void)_runMainWithOpeartion:(EXOperation *)operation{
    dispatch_sync([operation queue], ^{
        [operation prepareInQueue:self];
        [operation main];
        [operation completeInQueue:self];
    });
}

- (void)_completeWithOperation:(EXOperation *)operation{
    [_lock lock];
    [_excutingOperations removeObject:operation];
    BOOL continued = [_mutableOperations count] > 0;
    if (!continued) {
        [self _completeForCanceled:[operation isCancelled]];
    }
    [_lock unlock];
    
    if (continued) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self->_lock lock];
            [self _schedule];
            [self->_lock unlock];
        });
    }
}

- (void)_completeForCanceled:(BOOL)canceled{
    _executing = NO;
    
    if (_completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_completion(self, !canceled && !self->_canceled);
        });
    }
    [self _didEndSchedule];
}

- (long)_wait:(dispatch_time_t)timeout;{
    [_lock lock];
    dispatch_group_t group = _group;
    [_lock unlock];
    
    return dispatch_group_wait(group, timeout);
}

- (void)_willBeginSchedule;{}

- (void)_didEndSchedule;{}

@end
