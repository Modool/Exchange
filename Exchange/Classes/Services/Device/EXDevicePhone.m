//
//  EXDevicePhone.m
//  BBLink
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDevicePhone.h"
#import "EXDelegatesAccessor+EXAccessors.h"

#import "EXOperation.h"
#import "EXCompatQueue.h"
#import "EXCompatOperation.h"

#import "EXExchangeManager.h"
#import "EXProductManager+Compat.h"
#import "EXSocketManager.h"
#import "EXInitializer.h"
#import "EXDatabaseAccessor.h"

@implementation EXDevicePhone

- (NSArray<EXOperation *> *)prelaunchOperations{
    EXOperation *opration = [EXOperation operationWithConcurrent:NO block:^(EXOperation *operation) {
        [EXDelegatesAccessor addAccessor:[[EXInitializer alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXDatabaseAccessor alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXExchangeManager alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXProductManager alloc] init]];
        [EXDelegatesAccessor addAccessor:[[EXSocketManager alloc] init]];
    }];
    return @[opration];
}

- (NSArray<EXOperation *> *)compatOperations{
    return @[];
}

@end
