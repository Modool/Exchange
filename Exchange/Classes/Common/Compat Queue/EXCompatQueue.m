//
//  EXCompatQueue.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatQueue.h"
#import "EXCompatQueue+Private.h"

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
        self.key = key;
        self.currentVersion = currentVersion;
        
        @weakify(self);
        super.completion = ^(EXOperationQueue *queue, BOOL success){
            if (!success) return;
            
            @strongify(self);
            self.localVersion = currentVersion;
        };
    }
    return self;
}

#pragma mark - accessor

- (CGFloat)localVersion{
    return [[ACArchiverCenter defaultDeviceStorage] floatForKey:[self key]];
}

- (void)setLocalVersion:(CGFloat)localVersion{
    [[ACArchiverCenter defaultDeviceStorage] setFloat:localVersion forKey:[self key]];
}

#pragma mark - public

- (void)addOperation:(EXCompatOperation *)operation;{
    if (!operation) return;
    NSParameterAssert([operation isKindOfClass:[EXCompatOperation class]]);
    
    [self addOperations:@[operation]];
}

- (void)addOperations:(NSArray<EXCompatOperation *> *)operations;{
    for (EXCompatOperation *operation in operations) {
        NSParameterAssert([operation isKindOfClass:[EXCompatOperation class]]);
        
        @weakify(self);
        operation.block = ^(EXOperation *op) {
            @strongify(self);
            [(EXCompatOperation *)op _prepareCompatWithCurrentVersion:[self currentVersion] localVersion:[self localVersion]];
        };
    }
    
    [super addOperations:operations];
}

@end
