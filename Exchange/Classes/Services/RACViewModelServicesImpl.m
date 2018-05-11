//
//  RACControllerViewModelServicesImpl.m
//  ThaiynMall
//
//  Created by Marke Jave on 14/12/27.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import "RACViewModelServicesImpl.h"
#import "RACAppStoreServiceImpl.h"

@implementation RACViewModelServicesImpl
@synthesize client = _client, appStoreService = _appStoreService;

- (instancetype)initWithUnauthenticatedClient:(EXRACHTTPClient *)client;{
    if (self = [self init]) {
        self.client = client;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appStoreService = [RACAppStoreServiceImpl new];
    }
    return self;
}

- (void)pushViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated completion:(EXVoidBlock)completion {}

- (void)presentNavigationWithRootViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated completion:(EXVoidBlock)completion { }

- (void)dismissViewModelAnimated:(BOOL)animated completion:(EXVoidBlock)completion {}

- (void)resetRootViewModel:(RACControllerViewModel *)viewModel {}
- (void)resetRootNavigationWithViewModel:(RACControllerViewModel *)viewModel {}

@end
