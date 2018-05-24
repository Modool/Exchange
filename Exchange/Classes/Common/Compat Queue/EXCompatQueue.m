//
//  EXCompatQueue.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDOperations/MDOperations.h>
#import "EXCompatQueue.h"
#import "EXCompatQueue+Private.h"
#import "EXCompatOperation+Private.h"

@interface MDOperationQueue (EXPrivate)

- (void)_willBeginSchedule;
- (void)_didEndSchedule;

- (void)_lock:(void (^)(void))block;

@end

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
    __block CGFloat currentVersion = 0;
    [self _lock:^{
        currentVersion = self->_currentVersion;
    }];
    return currentVersion;
}

- (CGFloat)localVersion{
    __block CGFloat localVersion = 0;
    [self _lock:^{
        NSNumber *version = [ACArchiverCenter defaultDeviceStorage][self.key];
        if (!version) localVersion = -1;
        else localVersion = version.doubleValue;
    }];
    return localVersion;
}

- (void)setLocalVersion:(CGFloat)localVersion{
    [self _lock:^{
        [[ACArchiverCenter defaultDeviceStorage] setFloat:localVersion forKey:self.key];
    }];
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
