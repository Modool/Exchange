//
//  EXOperationQueue.m
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperationQueue.h"
#import "EXOperation+Private.h"

@interface EXOperationQueue () {
    NSUInteger _maximumConcurrentCount;
    BOOL _executing;
    BOOL _canceled;
}

@property (nonatomic, strong) NSMutableArray<EXOperation *> *mutableOperations;
@property (nonatomic, strong) NSMutableArray<EXOperation *> *excutingOperations;

@property (nonatomic, strong) dispatch_queue_t operationQueue;
@property (nonatomic, strong) dispatch_group_t group;

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
        self.mutableOperations = [NSMutableArray arrayWithArray:operations ?: @[]];
        self.excutingOperations = [NSMutableArray new];
        self.maximumConcurrentCount = NSUIntegerMax;
        
        NSString *queueName = [MDQueueObjectDomainPrefix stringByAppendingFormat:@"%@#Concurrent#%lu", NSStringFromClass([self class]), (unsigned long)self];
        self.operationQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        self.group = dispatch_group_create();
    }
    return self;
}

#pragma mark - accessor

- (NSArray<EXOperation *> *)operations{
    __block NSArray<EXOperation *> *operations = nil;
    dispatch_block_t block = ^{
        operations = [[self mutableOperations] copy];
    };
    
    [super sync:block];
    
    return operations;
}

- (NSUInteger)maximumConcurrentCount{
    __block NSUInteger maximumConcurrentCount = 0;
    dispatch_block_t block = ^{
        maximumConcurrentCount = self->_maximumConcurrentCount;
    };
    
    [super sync:block];
    
    return maximumConcurrentCount;
}

- (void)setMaximumConcurrentCount:(NSUInteger)maximumConcurrentCount{
    dispatch_block_t block = ^{
        self->_maximumConcurrentCount = maximumConcurrentCount;
    };
    
    [super sync:block];
}

- (BOOL)isExecuting{
    __block BOOL executing = NO;
    [super sync:^{
        executing = self->_executing;
    }];
    return executing;
}

- (BOOL)isCanceled{
    __block BOOL canceled = NO;
    [super sync:^{
        canceled = self->_canceled;
    }];
    return canceled;
}

#pragma mark - public

- (void)addOperation:(EXOperation *)operation;{
    if (!operation) return;
    
    [self addOperations:@[operation]];
}

- (void)addOperations:(NSArray<EXOperation *> *)operations;{
    if (![operations count]) return;
    
    dispatch_block_t block = ^{
        [self _addOperations:operations];
    };
    
    [super sync:block];
}

- (void)schedule;{
    NSParameterAssertReturnVoid(![self isExecuting]);
    
    dispatch_block_t block = ^{
        [self _schedule];
    };
    
    [super sync:block];
}

- (void)cancel;{
    dispatch_block_t block = ^{
        [self _cancel];
    };
    
    [super sync:block];
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
    dispatch_suspend([self operationQueue]);
    
    for (EXOperation *operation in [self mutableOperations]) {
        [operation cancel];
    }
    
    for (EXOperation *operation in [self excutingOperations]) {
        [operation cancel];
    }
    
    [[self mutableOperations] removeAllObjects];
    
    _canceled = YES;
    
    dispatch_resume([self operationQueue]);
}

- (void)_addOperations:(NSArray<EXOperation *> *)operations;{
    dispatch_suspend([self operationQueue]);
    
    [[self mutableOperations] addObjectsFromArray:operations];
    
    if (_executing) [self _schedule];
    
    dispatch_resume([self operationQueue]);
}

- (void)_schedule{
    NSArray<EXOperation *> *operations = [self operations];
    if(![operations count]) return;
    
    NSUInteger count = MIN([self maximumConcurrentCount] - [[self excutingOperations] count], [operations count]);
    if (!count) return;
    
    operations = [operations subarrayWithRange:NSMakeRange(0, count)];
    if(![operations count]) return;
    
    [[self mutableOperations] removeObjectsInArray:operations];
    
    _canceled = NO;
    
    [self _scheduleOperations:operations];
}

- (void)_scheduleOperations:(NSArray<EXOperation *> *)operations{
    if(![operations count]) return;
    
    [[self excutingOperations] addObjectsFromArray:operations];
    
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
    
    dispatch_group_async([self group], [self operationQueue], ^{
        for (EXOperation *operation in operations) {
            [self _runMainWithOpeartion:operation];
        }
    });
}

- (void)_runMainWithOpeartion:(EXOperation *)operation{
    dispatch_sync([operation queue], ^{
        [operation main];
    });
    
    dispatch_block_t block = ^{
        [self _completeWithOperation:operation];
    };
    
    [super sync:block];
}

- (void)_completeWithOperation:(EXOperation *)operation{
    [[self excutingOperations] removeObject:operation];
    
    if ([[self mutableOperations] count]) {
        [self _schedule];
    } else {
        [self _completeForCanceled:[operation isCancelled]];
    }
}

- (void)_completeForCanceled:(BOOL)canceled{
    _executing = NO;
    
    if ([self completion]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(self, !canceled && !self->_canceled);
        });
    }
}

- (long)_wait:(dispatch_time_t)timeout;{
    return dispatch_group_wait([self group], timeout);
}

@end
