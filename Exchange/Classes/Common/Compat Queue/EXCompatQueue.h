//
//  EXCompatQueue.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//


#import "EXOperationQueue.h"

@class EXCompatOperation;
@interface EXCompatQueue : EXOperationQueue

@property (copy, readonly) NSString *key;

@property (assign, readonly) CGFloat currentVersion;

+ (instancetype)queue EX_UNAVAILABLE;
+ (instancetype)queueWithOperations:(NSArray<EXOperation *> *)operations EX_UNAVAILABLE;
- (instancetype)initWithOperations:(NSArray<EXOperation *> *)operations EX_UNAVAILABLE;

+ (instancetype)queueWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;
- (instancetype)initWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;

- (void)addOperation:(EXCompatOperation *)operation;
- (void)addOperations:(NSArray<EXCompatOperation *> *)operations;

@end
