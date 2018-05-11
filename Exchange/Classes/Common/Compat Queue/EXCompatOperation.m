//
//  EXCompatOperation.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatOperation.h"
#import "EXCompatOperation+Private.h"
#import "EXCompatQueue+Private.h"

NSString * const EXCompatOperationVersionKeySuffix = @"VersionKey";

@implementation EXCompatOperation

+ (instancetype)operationWithVersion:(CGFloat)version block:(void (^)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion))block;{
    return [[self alloc] initWithVersion:version block:block];
}

- (instancetype)initWithVersion:(CGFloat)version block:(void (^)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion))block;{
    if (self = [super initWithConcurrent:NO block:nil]) {
        self.version = version;
        self.compatBlock = block;
    }
    return self;
}

- (instancetype)initWithConcurrent:(BOOL)concurrent block:(void (^)(EXOperation *operation))block;{
    return nil;
}

#pragma mark - private

- (void)_prepareCompatWithCurrentVersion:(CGFloat)currentVersion localVersion:(CGFloat)localVersion{
    NSParameterAssertReturnVoid([self version] >= currentVersion);
    
    // Compatible with the old version
    if (localVersion <= [self version]) {
        [self compatWithVersion:[self version] localVersion:localVersion];
    }
}

#pragma mark - protected

- (void)compatWithVersion:(CGFloat)version localVersion:(CGFloat)localVersion{
    if ([self compatBlock]) self.compatBlock(self, version, localVersion);
}

@end
