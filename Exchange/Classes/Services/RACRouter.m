//
//  RACRouter.m
//  MarkeJave
//
//  Created by Marke Jave on 14/12/27.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import "RACRouter.h"
#import "RACViewController.h"

@interface RACRouter ()

@end

@implementation RACRouter

+ (instancetype)sharedInstance {
    static RACRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (UIViewController *)viewControllerForViewModel:(RACControllerViewModel *)viewModel {
    NSParameterAssert([[viewModel viewControllerClass] isSubclassOfClass:[UIViewController class]]);
    NSParameterAssert([[viewModel viewControllerClass] instancesRespondToSelector:@selector(initWithViewModel:)]);
    return [[[viewModel viewControllerClass] alloc] initWithViewModel:viewModel];
}

@end
