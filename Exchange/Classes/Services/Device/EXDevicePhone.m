//
//  EXDevicePhone.m
//  EX
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
#import "EXProductManager.h"
#import "EXSocketManager.h"
#import "EXInitializer.h"
#import "EXDatabaseAccessor.h"

@implementation EXDevicePhone

+ (instancetype)device{
    NSArray<EXDelegatesAccessor> *modulers = (id)@[[[EXInitializer alloc] init],
                                                   [[EXDatabaseAccessor alloc] init],
                                                   [[EXExchangeManager alloc] init],
                                                   [[EXProductManager alloc] init],
                                                   [[EXSocketManager alloc] init]];
    
    EXOperation *operation = [[EXOperation alloc] init];
    operation.block = ^(EXOperation *operation) {
        for (id<EXDelegatesAccessor> moduler in modulers) {
            [EXDelegatesAccessor addAccessor:moduler];
        }
    };
    
    return [self deviceWithModulers:modulers prelaunchOperations:@[operation]];
}

@end
