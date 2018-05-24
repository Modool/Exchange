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

@interface MDOperation (EXPrivate)

- (void)_async:(dispatch_block_t)block;
- (void)_sync:(dispatch_block_t)block;

@end

@implementation EXCompatOperation

+ (instancetype)operationWithVersion:(CGFloat)version;{
    return [[self alloc] initWithVersion:version];
}

- (instancetype)initWithVersion:(CGFloat)version;{
    if (self = [super init]) {
        _version = version;
    }
    return self;
}

- (instancetype)init;{
    return [self initWithVersion:0];
}

- (void)setCompatBlock:(void (^)(EXCompatOperation *, CGFloat, CGFloat))compatBlock{
    [self _sync:^{
        self->_compatBlock = compatBlock;
    }];
}

- (void (^)(EXCompatOperation *, CGFloat, CGFloat))compatBlock{
    __block void (^compatBlock)(EXCompatOperation *, CGFloat, CGFloat) = nil;
    [self _sync:^{
        compatBlock = self->_compatBlock;
    }];
    return compatBlock;
}

#pragma mark - protected

- (void)prepareInQueue:(EXCompatQueue *)queue{
    _currentVersion = queue.currentVersion;
    _localVersion = queue.localVersion;
}

- (void)run{
    if (_version > _currentVersion) return;
    if (_localVersion >= _version) return;
    
    // Compatible with the old version
    [self compatWithVersion:_version localVersion:_localVersion];
    
    if (_compatBlock) _compatBlock(self, _version, _localVersion);
}

- (void)compatWithVersion:(CGFloat)version localVersion:(CGFloat)localVersion{}

@end
