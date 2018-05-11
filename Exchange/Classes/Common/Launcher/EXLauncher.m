//
//  EXLauncher.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXLauncher.h"

#import "EXCompatQueue.h"

#import "EXDefaultLoader.h"

#import "EXDevice.h"

@implementation EXLauncher{
    dispatch_once_t _onceToken;
}

#pragma mark - accessor

- (EXOperation *)prelaunchOperationWithDevice:(EXDevice *)device{
    EXOperationQueue *prelaunchQueue = [EXOperationQueue queue];
    // Added compat operations of managers.
    [prelaunchQueue addOperations:[device prelaunchOperations]];
    
    return [EXOperation operationWithConcurrent:NO block:^(EXOperation *operation) {
        [prelaunchQueue schedule];
        [prelaunchQueue waitUntilFinished];
    }];
}

- (EXOperation *)compatOperationWithDevice:(EXDevice *)device{
    EXOperationQueue *compatQueue = [EXOperationQueue queue];
    // Added compat operations of managers.
    [compatQueue addOperations:[device compatOperations]];
    
    return [EXOperation operationWithConcurrent:NO block:^(EXOperation *operation) {
        [compatQueue schedule];
        [compatQueue waitUntilFinished];
    }];
}

- (EXOperation *)loaderOperation;{
    return [EXOperation operationWithConcurrent:NO block:^(EXOperation *operation) {
        [[EXDefaultLoader defaultLoader] load];
    }];
}

#pragma mark - public

- (BOOL)launchWithDevice:(EXDevice *)device;{
    __block BOOL state = NO;
    EXOnce(&_onceToken, ^{
        [self sync:^{
            state = [self _launchWithDevice:device];
        }];
    });
    return state;
}

#pragma mark - private

- (BOOL)_launchWithDevice:(EXDevice *)device;{
    EXOperationQueue *launchQueue = [EXOperationQueue queue];

    EXOperation *prelaunchOperation = [self prelaunchOperationWithDevice:device];
    EXOperation *compatOperation = [self compatOperationWithDevice:device];
    EXOperation *loaderOperation = [self loaderOperation];
    
    [launchQueue addOperation:prelaunchOperation];
    [launchQueue addOperation:compatOperation];
    [launchQueue addOperation:loaderOperation];
    
    [launchQueue schedule];
    long state = [launchQueue waitUntilFinished];
    if (state) EXLog(@"Failed to launch.");
    
    return state == 0;
}

@end
