//
//  RACViewModel.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACViewModel.h"

@interface RACViewModel ()

@property (nonatomic, strong) RACSubject *errors;

@property (nonatomic, strong) NSMutableDictionary *keyPathAndValues;

@end

@implementation RACViewModel

#pragma mark - accessor

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (NSMutableDictionary *)keyPathAndValues{
    if (!_keyPathAndValues) {
        _keyPathAndValues = [NSMutableDictionary dictionary];
    }
    return _keyPathAndValues;
}

#pragma mark - protected

- (void)initialize {
    [[self errors] subscribeNext:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
