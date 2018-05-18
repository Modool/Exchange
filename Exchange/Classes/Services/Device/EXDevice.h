//
//  EXDevice.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>

@class EXOperation;
@protocol EXDelegatesAccessor;

@interface EXDevice : MDQueueObject

@property (nonatomic, copy, readonly) NSArray<EXDelegatesAccessor> *modulers;

@property (nonatomic, copy, readonly) NSArray<EXOperation *> *prelaunchOperations;

+ (instancetype)device;
+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;
+ (instancetype)deviceWithModulers:(NSArray<EXDelegatesAccessor> *)modulers prelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;


@end
