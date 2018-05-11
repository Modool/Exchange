//
//  MDQueuObject+RACSupport.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import "MDQueuObject+RACSupport.h"

@implementation MDQueueObject (RACSupport)

- (RACTargetQueueScheduler *)scheduler{
    RACTargetQueueScheduler *scheduler = objc_getAssociatedObject(self, @selector(scheduler));
    if (!scheduler) {
        scheduler = [[RACTargetQueueScheduler alloc] initWithName:[self name] targetQueue:[self queue]];
        objc_setAssociatedObject(self, @selector(scheduler), scheduler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return scheduler;
}

@end
