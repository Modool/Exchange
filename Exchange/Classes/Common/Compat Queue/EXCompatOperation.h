//
//  EXCompatOperation.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDOperations/MDOperations.h>

EX_EXTERN NSString * const EXCompatOperationVersionKeySuffix;

@interface EXCompatOperation : MDOperation

@property (assign, readonly) CGFloat version;

@property (copy) void (^compatBlock)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion);

+ (instancetype)operationWithVersion:(CGFloat)version;
- (instancetype)initWithVersion:(CGFloat)version NS_DESIGNATED_INITIALIZER;

#pragma mark - protected

- (void)compatWithVersion:(CGFloat)version localVersion:(CGFloat)localVersion NS_REQUIRES_SUPER;

@end
