//
//  UIMenuItem+EXAdditions.m
//  Exchange
//
//  Created by 李小虎 on 2018/1/29.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "UIMenuItem+EXAdditions.h"

@implementation UIMenuItem (EXAdditions)

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action command:(RACCommand *)command{
    NSParameterAssertReturnNil(title && target && action && command);
    if (self =  [self initWithTitle:title action:action]) {
        [[[target rac_signalForSelector:action] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
            [command execute:x];
        }];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action userInfo:(id)userInfo command:(RACCommand *)command{
    NSParameterAssertReturnNil(title && target && action && userInfo && command);
    if (self =  [self initWithTitle:title action:action]) {
        [[[target rac_signalForSelector:action] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
            [command execute:userInfo];
        }];
    }
    return self;
}
@end
