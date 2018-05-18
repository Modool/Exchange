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

#pragma mark - public

- (BOOL)launchWithDevice:(EXDevice *)device;{
    __block BOOL state = NO;
    EXOnce(&_onceToken, ^{
        state = [self _launchWithDevice:device];
    });
    return state;
}

#pragma mark - private

- (BOOL)_launchWithDevice:(EXDevice *)device;{
    EXOperationQueue *prelauncQueue = [EXOperationQueue queueWithOperations:[device prelaunchOperations]];
    [prelauncQueue schedule];
    long state = [prelauncQueue waitUntilFinished];
    if (state) {
        EXLog(@"Failed to prelaunch.");
        return NO;
    }
    
    [[EXDefaultLoader defaultLoader] loadWithDevice:device];
    
    return YES;
}

@end
