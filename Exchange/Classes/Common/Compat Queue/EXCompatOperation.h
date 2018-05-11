//
//  EXCompatOperation.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperation.h"

EX_EXTERN NSString * const EXCompatOperationVersionKeySuffix;

@interface EXCompatOperation : EXOperation

@property (nonatomic, assign, readonly) CGFloat version;

+ (instancetype)operationWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block EX_UNAVAILABLE;
- (instancetype)initWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block EX_UNAVAILABLE;

+ (instancetype)operationWithVersion:(CGFloat)version block:(void (^)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion))block;
- (instancetype)initWithVersion:(CGFloat)version block:(void (^)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion))block NS_DESIGNATED_INITIALIZER;

#pragma mark - protected

- (void)compatWithVersion:(CGFloat)version localVersion:(CGFloat)localVersionNS_REQUIRES_SUPER;

@end
