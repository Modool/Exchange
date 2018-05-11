//
//  RACSignal+RACSubscribe.m
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACSignal+RACSubscribe.h"

@implementation RACSignal (RACSubscribe)

- (void)subscribeToSubject:(RACSubject *)subject;{
    @weakify(subject);
    [self subscribeNext:^(id x) {
        @strongify(subject);
        [subject sendNext:x];
    }];
}

- (void)subscribeToSubject:(RACSubject *)subject input:(id)input;{
    @weakify(subject);
    [self subscribeNext:^(id x) {
        @strongify(subject);
        [subject sendNext:input];
    }];
}

- (void)subscribeToCommand:(RACCommand *)command;{
    @weakify(command);
    [self subscribeNext:^(id x) {
        @strongify(command);
        [command execute:x];
    }];
}

- (void)subscribeToCommand:(RACCommand *)command input:(id)input;{
    @weakify(command);
    [self subscribeNext:^(id x) {
        @strongify(command);
        [command execute:input];
    }];
}

- (void)subscribeToPerformSelector:(SEL)selector;{
    return [self subscribeToPerformSelector:selector object:nil];
}

- (void)subscribeToPerformSelector:(SEL)selector object:(id)object;{
    return [self subscribeToPerformSelector:selector object:object object:nil];
}

- (void)subscribeToPerformSelector:(SEL)selector object:(id)object1 object:(id)object2;{
    @weakify(object1);
    @weakify(object2);
    [self subscribeNext:^(id x) {
        @strongify(object1);
        @strongify(object2);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [x performSelector:selector withObject:object1 withObject:object2];
#pragma clang diagnostic pop
    }];
}

- (void)subscribeToTarget:(id)target performSelector:(SEL)selector;{
    return [self subscribeToTarget:target performSelector:selector object:nil];
}

- (void)subscribeToTarget:(id)target performSelector:(SEL)selector object:(id)object;{
    return [self subscribeToTarget:target performSelector:selector object:object object:nil];
}

- (void)subscribeToTarget:(id)target performSelector:(SEL)selector object:(id)object1 object:(id)object2;{
    @weakify(target);
    @weakify(object1);
    @weakify(object2);
    [self subscribeNext:^(id x) {
        @strongify(target);
        @strongify(object1);
        @strongify(object2);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector withObject:object1 withObject:object2];
#pragma clang diagnostic pop
    }];
}

- (void)subscribeToCommandSwitch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs;{
    @weakify(cases);
    @weakify(inputs);
    [self subscribeNext:^(NSNumber *x) {
        @strongify(cases);
        @strongify(inputs);
        __weak RACCommand *command = cases[x];
        id input = inputs[x];
        if (command) [command execute:input];
    }];
}

- (void)subscribeMapKeypath:(NSString *)keypath switch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs;{
    return [self subscribeMapKeypath:keypath switch:cases inputs:inputs unvarnishe:NO];
}

- (void)subscribeMapKeypath:(NSString *)keypath switch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs unvarnishe:(BOOL)unvarnishe;{
    @weakify(cases);
    @weakify(inputs);
    [self subscribeNext:^(id x) {
        @strongify(cases);
        @strongify(inputs);
        id value = [x valueForKeyPath:keypath];
        
        RACCommand *command = cases[value];
        id input = inputs[value];
        if (unvarnishe && !input) input = x;
        if (unvarnishe && input) input = RACTuplePack(x, input);
        
        if (command) [command execute:input];
    }];
}

@end
