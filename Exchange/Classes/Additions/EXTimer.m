//
//  EXTimer.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTimer.h"

@interface EXTimer ()

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation EXTimer

+ (instancetype)timerWithInterval:(NSTimeInterval)interval target:(id)target action:(SEL)action;{
    return [[self alloc] initWithInterval:interval target:target action:action];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)target action:(SEL)action;{
    if (self = [super init]) {
        self.interval = interval;
        self.target = target;
        self.action = action;
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)dealloc{
    [self stop];
}

#pragma mark - accessor

- (void)setOffset:(NSTimeInterval)offset{
    [self.lock lock];
    
    if (_offset != offset) {
        _offset = offset;
        
        if (_timer) [self _reschedule];
    }
    [self.lock unlock];
}

- (void)setTargetQueue:(dispatch_queue_t)targetQueue{
    [self.lock lock];
    
    if (_targetQueue != targetQueue) {
        _targetQueue = targetQueue;
        
        if (_timer) [self _reschedule];
    }
    [self.lock unlock];
}

#pragma mark - public

- (void)schedule;{
    [self.lock lock];
    
    if (_timer) dispatch_source_cancel(_timer);
    if (_interval < 0) return;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.class._sharedQueue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC, _offset * NSEC_PER_SEC);
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        [self _handleTimerEvent];
    });
    dispatch_resume(_timer);
    
    [self.lock unlock];
}

- (void)stop;{
    [self.lock lock];
    
    if (_timer) dispatch_source_cancel(_timer);
    
    _timer = nil;
    [self.lock unlock];
}

#pragma mark - private

+ (dispatch_queue_t)_sharedQueue{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.markjave.exchange.timer.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (void)_reschedule{
    [self stop];
    [self schedule];
}

- (void)_handleTimerEvent{
    if (!_target) [self stop];
    
    if (_target && _action) {
        dispatch_async(_targetQueue ?: dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self->_target performSelector:self->_action withObject:self];
#pragma clang diagnostic pop
        });
    };
}

@end
