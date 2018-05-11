//
//  RACSignal+RACConstruct.m
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACSignal+RACConstruct.h"

@implementation RACSignal (RACConstruct)

+ (RACSignal *)createDispersedSignal:(void(^)(id<RACSubscriber> subscriber))didSubscribe;{
    NSParameterAssertReturnNil(didSubscribe);
    return [self createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        didSubscribe(subscriber);
        return nil;
    }];
}

@end
