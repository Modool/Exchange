//
//  EXOperation.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXMacros.h"

@interface EXOperation : NSObject

@property (strong, readonly) dispatch_queue_t queue;

@property (assign, readonly, getter=isExecuting) BOOL executing;

@property (assign, readonly, getter=isFinished) BOOL finished;

@property (assign, readonly, getter=isCancelled) BOOL cancelled;

@property (assign, getter=isConcurrent) BOOL concurrent;

@property (copy) void (^block)(EXOperation *operation);

- (void)cancel;
- (void)synchronize;
- (void)asynchronize;

@end
