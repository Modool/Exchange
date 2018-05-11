//
//  EXTimer.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXTimer : NSObject

@property (nonatomic, assign) NSTimeInterval offset;

// default is dispatch_get_main_queue.
@property (nonatomic, strong) dispatch_queue_t targetQueue;

+ (instancetype)timerWithInterval:(NSTimeInterval)interval target:(id)target action:(SEL)action;
- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)target action:(SEL)action;

- (void)schedule;
- (void)stop;

@end
