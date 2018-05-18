//
//  EXCompatQueue.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatQueue.h"
#import "EXCompatQueue+Private.h"
#import "EXOperationQueue+Private.h"

#import "EXOperation+Private.h"
#import "EXCompatOperation+Private.h"

@implementation EXCompatQueue
@dynamic completion;

+ (instancetype)queueWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;{
    return [[self alloc] initWithKey:key currentVersion:currentVersion];
}

- (instancetype)initWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion;{
    return [self initWithKey:key currentVersion:currentVersion operations:nil];
}

+ (instancetype)queueWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion operations:(NSArray<EXCompatOperation *> *)operations;{
    return [[self alloc] initWithKey:key currentVersion:currentVersion operations:operations];
}

- (instancetype)initWithKey:(NSString *)key currentVersion:(CGFloat)currentVersion operations:(NSArray<EXCompatOperation *> *)operations;{
    if (self = [super initWithOperations:operations]) {
        _key = key;
        _currentVersion = currentVersion;
    }
    return self;
}

#pragma mark - accessor

- (CGFloat)currentVersion{
    [_lock lock];
    CGFloat currentVersion = _currentVersion;
    [_lock unlock];
    return currentVersion;
}

- (CGFloat)localVersion{
    CGFloat localVersion = 0;
    [_lock lock];
    NSNumber *version = [ACArchiverCenter defaultDeviceStorage][[self key]];
    if (!version) localVersion = -1;
    else return localVersion = version.doubleValue;
    [_lock unlock];
    return localVersion;
}

- (void)setLocalVersion:(CGFloat)localVersion{
    [_lock lock];
    [[ACArchiverCenter defaultDeviceStorage] setFloat:localVersion forKey:[self key]];
    [_lock unlock];
}

#pragma mark - public

- (void)addOperation:(EXCompatOperation *)operation;{
    if (!operation) return;
    NSParameterAssert([operation isKindOfClass:[EXCompatOperation class]]);
    
    [self addOperations:@[operation]];
}

- (void)addOperations:(NSArray<EXCompatOperation *> *)operations;{
    [super addOperations:operations];
}

- (void)_didEndSchedule{
    [super _didEndSchedule];
    
    self.localVersion = _currentVersion;
}

@end
