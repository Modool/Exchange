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

@property (nonatomic, copy, readonly) NSString *key;

@property (nonatomic, assign, readonly) CGFloat currentVersion;

@property (nonatomic, copy) void (^completion)(EXOperationQueue *queue, BOOL success) EX_UNAVAILABLE;

+ (instancetype)queue EX_UNAVAILABLE;
+ (instancetype)queueWithOperations:(NSArray<EXOperation *> *)operations EX_UNAVAILABLE;
- (instancetype)initWithOperations:(NSArray<EXOperation *> *)operations EX_UNAVAILABLE;

+ (instancetype)queueWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;
- (instancetype)initWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;

+ (instancetype)queueWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion operations:(NSArray<EXCompatOperation *> *)operations;
- (instancetype)initWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion operations:(NSArray<EXCompatOperation *> *)operations;

- (void)addOperation:(EXCompatOperation *)operation;
- (void)addOperations:(NSArray<EXCompatOperation *> *)operations;

@end
