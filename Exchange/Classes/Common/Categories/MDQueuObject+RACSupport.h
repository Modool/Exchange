//
//  MDQueuObject+RACSupport.h
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>

@class RACTargetQueueScheduler;
@interface MDQueueObject (RACSupport)

@property (nonatomic, strong, readonly) RACTargetQueueScheduler *scheduler;

@end
