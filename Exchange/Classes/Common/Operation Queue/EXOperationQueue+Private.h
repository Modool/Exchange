//
//  EXOperationQueue+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperationQueue.h"

@interface EXOperation (EXOperationQueue)

- (void)prepareInQueue:(EXOperationQueue *)queue;
- (void)completeInQueue:(EXOperationQueue *)queue;

@end

@interface EXOperationQueue () {
    @protected
    NSMutableArray<EXOperation *> *_mutableOperations;
    NSMutableArray<EXOperation *> *_excutingOperations;
    
    NSRecursiveLock *_lock;
    
    dispatch_queue_t _queue;
    dispatch_group_t _group;
    
    NSUInteger _maximumConcurrentCount;
    
    BOOL _executing;
    BOOL _canceled;
    
    void (^_completion)(EXOperationQueue *queue, BOOL success);
}

- (void)_willBeginSchedule;
- (void)_didEndSchedule;

@end
