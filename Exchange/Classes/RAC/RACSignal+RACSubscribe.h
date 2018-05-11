//
//  RACSignal+RACSubscribe.h
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (RACSubscribe)

- (void)subscribeToSubject:(RACSubject *)subject;
- (void)subscribeToSubject:(RACSubject *)subject input:(id)input;

- (void)subscribeToCommand:(RACCommand *)command;
- (void)subscribeToCommand:(RACCommand *)command input:(id)input;

- (void)subscribeToPerformSelector:(SEL)selector;
- (void)subscribeToPerformSelector:(SEL)selector object:(id)object;
- (void)subscribeToPerformSelector:(SEL)selector object:(id)object1 object:(id)object2;

- (void)subscribeToTarget:(id)target performSelector:(SEL)selector;
- (void)subscribeToTarget:(id)target performSelector:(SEL)selector object:(id)object;
- (void)subscribeToTarget:(id)target performSelector:(SEL)selector object:(id)object1 object:(id)object2;

- (void)subscribeToCommandSwitch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs;
- (void)subscribeMapKeypath:(NSString *)keypath switch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs;
- (void)subscribeMapKeypath:(NSString *)keypath switch:(NSDictionary<id, RACCommand *> *)cases inputs:(NSDictionary<id, id> *)inputs unvarnishe:(BOOL)unvarnishe;

@end
