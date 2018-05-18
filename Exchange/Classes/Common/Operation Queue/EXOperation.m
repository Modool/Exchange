//
//  EXOperation.m
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperation.h"
#import "EXOperation+Private.h"

NSString * const EXOperationDomainPrefix = @"com.markejave.modool.operation";

@implementation EXOperation

+ (instancetype)operationWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;{
    return [[self alloc] initWithConcurrent:concurrent block:block];
}

- (instancetype)initWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;{
    if (self = [super init]) {
        _name = [NSString stringWithFormat:@"%@%lu", EXOperationDomainPrefix, (unsigned long)self];
        _queue = dispatch_queue_create([_name UTF8String], NULL);
        
        _queueTag = &_queueTag;
        dispatch_queue_set_specific(_queue, _queueTag, _queueTag, NULL);

        _concurrent = concurrent;
        _block = block;
    }
    return self;
}

- (instancetype)init{
    return [self initWithConcurrent:NO block:nil];
}

#pragma mark - accessor

- (BOOL)isConcurrent{
    __block BOOL concurrent = NO;
    [self _sync:^{
        concurrent = self->_concurrent;
    }];
    return concurrent;
}

- (void)setConcurrent:(BOOL)concurrent{
    [self _sync:^{
        self->_concurrent = concurrent;
    }];
}

- (BOOL)isExecuting{
    __block BOOL executing = NO;
    [self _sync:^{
        executing = self->_executing;
    }];
    return executing;
}

- (BOOL)isFinished{
    __block BOOL finished = NO;
    [self _sync:^{
        finished = self->_finished;
    }];
    return finished;
}

- (BOOL)isCancelled{
    __block BOOL cancelled = NO;
    [self _sync:^{
        cancelled = self->_cancelled;
    }];
    return cancelled;
}

- (void (^)(EXOperation *))block{
    __block void (^block)(EXOperation *);
    [self _sync:^{
        block = self->_block;
    }];
    return block;
}

- (void)setBlock:(void (^)(EXOperation *))block{
    [self _sync:^{
        self->_block = block;
    }];
}

- (dispatch_queue_t)queue{
    __block dispatch_queue_t queue = nil;
    [self _sync:^{
        queue = self->_queue;
    }];
    return queue;
}

#pragma mark - public

- (void)cancel;{
    _cancelled = YES;
}

- (void)synchronize;{
    [self _sync:^{
        [self main];
    }];
}

- (void)asynchronize;{
    [self _async:^{
        [self main];
    }];
}

#pragma mark - private

- (void)_async:(dispatch_block_t)block;{
    if (dispatch_get_specific(_queueTag)) {
        block();
    } else {
        dispatch_async(_queue, block);
    }
}

- (void)_sync:(dispatch_block_t)block;{
    if (dispatch_get_specific(_queueTag)) {
        block();
    } else {
        dispatch_sync(_queue, block);
    }
}

- (void)main{
    if (_cancelled) return;
    if (_finished) return;
    
    _executing = YES;
    
    if (_block) _block(self);
    [self run];
    
    _executing = NO;
    _finished = YES;
}

- (void)run;{}

@end
