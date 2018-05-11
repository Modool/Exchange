//
//  EXRootViewController.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXRootViewController.h"
#import "EXRootViewModel.h"

#import "RACNavigationControllerStack.h"
#import "UIViewController+EXAdditions.h"

@interface EXRootViewController ()

@property (nonatomic, strong, readonly) EXRootViewModel *viewModel;

@end

@implementation EXRootViewController
@dynamic viewModel;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    [RACObserve([self tabBarController], viewControllers) subscribeNext:^(NSArray<UINavigationController *> *navigationControllers) {
        for (UINavigationController *navigationController in navigationControllers) {
            if (![navigationController isKindOfClass:[UINavigationController class]]) continue;
            
            navigationController.delegate = [MDNavigationControllerDelegate defaultDelegate];
            navigationController.allowPushAnimation = YES;
        }
        
        RACNavigationControllerStack *stack = [EXSharedAppDelegate viewControllerStack];
        if ([navigationControllers count]) {
            [stack pushNavigationController:[navigationControllers firstObject]];
        } else if ([stack topNavigationController]){
            [stack  popNavigationController];
        }
    }];
    
    [[self rac_signalForSelector:@selector(tabBarController:didSelectViewController:) fromProtocol:@protocol(UITabBarControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(UITabBarController *tabBarController, UINavigationController *selectedViewController) = tuple;
        RACNavigationControllerStack *stack = [EXSharedAppDelegate viewControllerStack];
        if (stack.topNavigationController != selectedViewController) {
            [stack popNavigationController];
            [stack pushNavigationController:selectedViewController];
        } else {
            NSUInteger index = [tabBarController.viewControllers indexOfObject:selectedViewController];
            UIViewController *visibleViewController = selectedViewController.topVisibleViewController;
            [[NSNotificationCenter defaultCenter] postNotificationName:EXExchangeDidDoubleClickTabBarItemNotification object:visibleViewController userInfo:@{@"index": @(index)}];
        }
     }];
}

@end
