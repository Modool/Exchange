//
//  RACAppStoreServiceImpl.m
//  MarkeJave
//
//  Created by MarkeJave on 15/3/6.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import "RACAppStoreServiceImpl.h"

@implementation RACAppStoreServiceImpl

- (RACSignal *)requestAppInfoFromAppStoreWithAppID:(NSString *)appID {
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLazily] setNameWithFormat:@"-requestAppInfoFromAppStoreWithAppID: %@", appID];
}

@end
