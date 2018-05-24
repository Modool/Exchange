//
//  EXDevice.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>

@class MDOperation;
@protocol EXDelegatesAccessor;

@interface EXDevice : MDQueueObject

@property (nonatomic, copy, readonly) NSArray<EXDelegatesAccessor> *modulers;

@property (nonatomic, copy, readonly) NSArray<MDOperation *> *prelaunchOperations;

+ (instancetype)device;
+ (instancetype)deviceWithPrelaunchOperations:(NSArray<MDOperation *> *)prelaunchOperations;
+ (instancetype)deviceWithModulers:(NSArray<EXDelegatesAccessor> *)modulers prelaunchOperations:(NSArray<MDOperation *> *)prelaunchOperations;


@end
