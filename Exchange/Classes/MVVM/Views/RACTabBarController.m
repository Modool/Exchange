//
//  RACTabBarController.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACTabBarController.h"
#import "RACMultipleViewModel.h"
#import "RACRouter.h"
#import "UIViewController+EXAdditions.h"

@interface RACTabBarController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong, readonly) RACMultipleViewModel *viewModel;

@end

@implementation RACTabBarController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.tabBarController = [UITabBarController new];
    
    [self addChildViewController:[self tabBarController]];
    [[self view] addSubview:[[self tabBarController] view]];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    RAC(self.viewModel, currentIndex) = RACObserve(self.tabBarController, selectedIndex);
    
    [[[RACObserve(self.viewModel, viewModels) map:^id(NSArray<RACControllerViewModel *> *viewModels) {
        return [[[viewModels rac_sequence] map:^id(RACControllerViewModel *viewModel) {
            UIViewController *controller = [[RACRouter sharedInstance] viewControllerForViewModel:viewModel];
            controller.title = [viewModel title];
            controller.tabBarItem = [viewModel tabBarItem];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            
            if (@available(iOS 11, *)) {
                navigationController.navigationBar.prefersLargeTitles = YES;
            }
            
            return navigationController;
        }] array];
    }] combineLatestWith:[RACObserve(self, tabBarController) ignore:nil]] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSArray<UINavigationController *> *viewControllers, UITabBarController *tabBarController) = tuple;
        
        [tabBarController setViewControllers:viewControllers animated:YES];
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.tabBarController.view.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tabBarController.view.frame = self.view.bounds;
}

@end

@implementation RACTabBarController (EXVisibleViewController)

- (UINavigationController *)topNavigationController{
    UINavigationController *topNavigationController = [super topNavigationController];
    return topNavigationController ?: [[self tabBarController] topNavigationController];
}

- (UIViewController*)topVisibleViewController;{
    UIViewController *topVisibleViewController = [super topVisibleViewController];
    if (topVisibleViewController == self) return [[self tabBarController] topVisibleViewController];
    return topVisibleViewController;
}

@end
