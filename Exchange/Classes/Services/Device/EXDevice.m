//
//  EXDevice.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDevice.h"

@implementation EXDevice

+ (instancetype)device;{
    return [self deviceWithPrelaunchOperations:nil];
}

+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;{
    return [self deviceWithModulers:nil prelaunchOperations:prelaunchOperations];
}

+ (instancetype)deviceWithModulers:(NSArray<EXDelegatesAccessor> *)modulers prelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;{
    EXDevice *device = [self new];
    device->_modulers = [modulers copy];
    device->_prelaunchOperations = [prelaunchOperations copy];
    
    return device;
}

@end
