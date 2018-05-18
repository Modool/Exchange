//
//  EXOperation+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperation.h"

@class EXOperationQueue;
@interface EXOperation (){
    void *_queueTag;
    
    NSString *_name;
    dispatch_queue_t _queue;
    
    BOOL _concurrent;
    BOOL _executing;
    BOOL _finished;
    BOOL _cancelled;
    void (^_block)(EXOperation *operation);
}

- (void)_async:(dispatch_block_t)block;
- (void)_sync:(dispatch_block_t)block;

- (void)main;
- (void)run;

@end
