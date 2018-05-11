//
//  EXOperation.m
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperation.h"
#import "EXOperation+Private.h"

@implementation EXOperation

+ (instancetype)operationWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;{
    return [[self alloc] initWithConcurrent:concurrent block:block];
}

- (instancetype)initWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;{
    NSParameterAssert(block);
    
    if (self = [super init]) {
        self.concurrent = concurrent;
        self.block = block;
    }
    return self;
}

#pragma mark - accessor

- (BOOL)isConcurrent{
    __block BOOL concurrent = NO;
    [super sync:^{
        concurrent = self->_concurrent;
    }];
    return concurrent;
}

#pragma mark - public

- (void)cancel;{
    _cancelled = YES;
}

#pragma mark - private

- (void)main{
    if (_cancelled) return;
    if (_finished) return;
    
    _executing = YES;
    
    if ([self block]) self.block(self);
    [self run];
    
    _executing = NO;
    _finished = YES;
}

- (void)run;{
    
}

@end
