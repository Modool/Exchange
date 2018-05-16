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
    return [self deviceWithPrelaunchOperations:nil compatOperations:nil];
}

+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;{
    return [self deviceWithPrelaunchOperations:prelaunchOperations compatOperations:nil];
}

+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations compatOperations:(NSArray<EXOperation *> *)compatOperations;{
    EXDevice *device = [self new];
    device->_prelaunchOperations = [prelaunchOperations copy];
    device->_compatOperations = [compatOperations copy];
    
    return device;
}

@end
