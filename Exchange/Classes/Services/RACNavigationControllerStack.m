//
//  RACNavigationControllerStack.m
//  MarkeJave
//
//  Created by Marke Jave on 15/1/10.
//  Copyright (c) 2018年 Marke Jave. All rights reserved.
//

#import "RACNavigationControllerStack.h"
#import "RACNavigationProtocol.h"
#import "RACRouter.h"

@interface RACNavigationControllerStack ()

@property (nonatomic, strong) NSObject<RACViewModelServices> *services;
@property (nonatomic, strong) NSMutableArray *viewControllersStack;

@end

@implementation RACNavigationControllerStack

- (instancetype)initWithServices:(NSObject<RACViewModelServices> *)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.viewControllersStack = [[NSMutableArray alloc] init];
        [self registerNavigationHooks];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    NSParameterAssert(navigationController);
    NSParameterAssert([navigationController isKindOfClass:[UINavigationController class]]);
    [self presentViewController:navigationController];
}

- (void)presentViewController:(UIViewController *)viewController;{
    NSParameterAssert(viewController);
    NSParameterAssert([viewController isKindOfClass:[UIViewController class]]);
    if ([[self viewControllersStack] containsObject:viewController]) return;
    [[self viewControllersStack] addObject:viewController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = [[self viewControllersStack] lastObject];
    NSParameterAssert([navigationController isKindOfClass:[UINavigationController class]]);
    [[self viewControllersStack] removeLastObject];
    return navigationController;
}

- (UIViewController *)dismissPresentingViewController;{
    UIViewController *viewController = [[self viewControllersStack] lastObject];
    [[self viewControllersStack] removeLastObject];
    return viewController;
}

- (UINavigationController *)topNavigationController {
    __block UINavigationController *navigationController = [[self viewControllersStack] lastObject];
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        [[self viewControllersStack] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UINavigationController *enumerateNavigationController, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([enumerateNavigationController isKindOfClass:[UINavigationController class]]) {
                navigationController = enumerateNavigationController;
                *stop = YES;
            }
        }];
    }
    return navigationController;
}

- (UIViewController *)topViewController;{
    return [[self viewControllersStack] lastObject];
}

- (void)registerNavigationHooks {
    @weakify(self);
    [[[self services] rac_signalForSelector:@selector(pushViewModel:animated:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UINavigationController *topNavigationController = [[self viewControllersStack] lastObject];
        NSParameterAssert([topNavigationController isKindOfClass:[UINavigationController class]]);

        UIViewController *viewController = [[RACRouter sharedInstance] viewControllerForViewModel:[tuple first]];
        viewController.hidesBottomBarWhenPushed = YES;
        [topNavigationController pushViewController:viewController animated:[[tuple second] boolValue]];
    }];
    [[[self services] rac_signalForSelector:@selector(popViewModelAnimated:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UINavigationController *topNavigationController = [[self viewControllersStack] lastObject];
        NSParameterAssert([topNavigationController isKindOfClass:[UINavigationController class]]);
        NSParameterAssert([[topNavigationController childViewControllers] count] > 1);
        [topNavigationController popViewControllerAnimated:[[tuple first] boolValue]];
    }];
    [[[self services] rac_signalForSelector:@selector(popToRootViewModelAnimated:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UINavigationController *topNavigationController = [[self viewControllersStack] lastObject];
        NSParameterAssert([[topNavigationController childViewControllers] count] > 1);
        [topNavigationController popToRootViewControllerAnimated:[[tuple first] boolValue]];
    }];
    [[[self services] rac_signalForSelector:@selector(presentViewModel:animated:completion:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UIViewController *presentingViewController = [[self viewControllersStack] lastObject];
        UIViewController *viewController = [[RACRouter sharedInstance] viewControllerForViewModel:[tuple first]];
        [self presentViewController:viewController];
        [presentingViewController presentViewController:viewController animated:[[tuple second] boolValue] completion:[tuple third]];
    }];
    [[[self services] rac_signalForSelector:@selector(presentNavigationWithRootViewModel:animated:completion:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UIViewController *presentingViewController = [[self viewControllersStack] lastObject];
        UIViewController *viewController = [[RACRouter sharedInstance] viewControllerForViewModel:[tuple first]];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController];
        [presentingViewController presentViewController:navigationController animated:[[tuple second] boolValue] completion:[tuple third]];
    }];
    [[[self services] rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UIViewController *topViewContoller = [[self viewControllersStack] lastObject];
        NSAssert1(![topViewContoller tabBarController], @"The view controller is root %@", [topViewContoller  class]);
        if (![topViewContoller tabBarController]) {
            [[self viewControllersStack] removeLastObject];
            [topViewContoller dismissViewControllerAnimated:[[tuple first] boolValue] completion:[tuple second]];
        }
    }];
    [[[self services] rac_signalForSelector:@selector(resetRootViewModel:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [[self viewControllersStack] removeAllObjects];
        UIViewController *viewController = (UIViewController *)[[RACRouter sharedInstance] viewControllerForViewModel:[tuple first]];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = viewController;
    }];
    
    [[[self services] rac_signalForSelector:@selector(resetRootNavigationWithViewModel:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [[self viewControllersStack] removeAllObjects];
        UIViewController *viewController = (UIViewController *)[[RACRouter sharedInstance] viewControllerForViewModel:[tuple first]];
        if (![viewController isKindOfClass:[UINavigationController class]] &&
            ![viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self pushNavigationController:(UINavigationController *)viewController];
        }
        EXSharedAppDelegate.window.rootViewController = viewController;
    }];
}

@end
