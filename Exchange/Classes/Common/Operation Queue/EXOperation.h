//
//  EXOperation.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>
#import "EXMacros.h"

@interface EXOperation : MDQueueObject

@property (nonatomic, assign, readonly, getter=isConcurrent) BOOL concurrent;

@property (nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

@property (nonatomic, assign, readonly, getter=isFinished) BOOL finished;

@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

- (instancetype)init EX_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name EX_UNAVAILABLE;

+ (instancetype)operationWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;
- (instancetype)initWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;

- (void)cancel;

@end
