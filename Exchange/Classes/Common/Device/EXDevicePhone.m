//
//  EXDevicePhone.m
//  BBLink
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "EXDevicePhone.h"
#import "EXDelegatesAccessor+EXAccessors.h"

#import "EXOperation.h"
#import "EXCompatQueue.h"
#import "EXCompatOperation.h"

#import "EXExchangeManager.h"
#import "EXProductManager.h"
#import "EXSocketManager.h"

@implementation EXDevicePhone

- (NSArray<EXOperation *> *)prelaunchOperations{
    EXOperation *opration = [EXOperation operationWithConcurrent:NO block:^(EXOperation *operation) {
        [EXDelegatesAccessor addAccessor:[[EXExchangeManager alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXProductManager alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXSocketManager alloc] init]];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    }];
    return @[opration];
}

- (NSArray<EXOperation *> *)compatOperations{
    return @[];
}

@end
