//
//  EXDevice.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDQueueObject/MDQueueObject.h>

@class EXOperation, EXCompatOperation;
@interface EXDevice : MDQueueObject

@property (nonatomic, copy, readonly) NSArray<EXOperation *> *prelaunchOperations;

@property (nonatomic, copy, readonly) NSArray<EXOperation *> *compatOperations;

+ (instancetype)device;
+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations;
+ (instancetype)deviceWithPrelaunchOperations:(NSArray<EXOperation *> *)prelaunchOperations compatOperations:(NSArray<EXOperation *> *)compatOperations;

@end
