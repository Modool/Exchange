
//
//  RACSegmentViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACSegmentViewController.h"
#import "RACMultipleViewModel.h"
#import "UIViewController+EXAdditions.h"

@interface RACSegmentViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;

@end

@implementation RACSegmentViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.navigationItem.titleView = self.segmentControl;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    RAC(self.viewModel, currentIndex) = [[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISegmentedControl *segmentControl) {
        return @([segmentControl selectedSegmentIndex]);
    }];
    
    RAC(self, viewControllers) = [RACObserve(self.viewModel, viewModels) map:^NSArray<UIViewController *> *(NSArray<RACControllerViewModel *> *viewModels) {
        return [[[viewModels rac_sequence] map:^UIViewController *(RACControllerViewModel *viewModel) {
            return [[[viewModel viewControllerClass] alloc] initWithViewModel:viewModel];
        }] array];
    }];
    
    [RACObserve(self.viewModel, viewModels) subscribeNext:^(NSArray<RACControllerViewModel *> *viewModels) {
        @strongify(self);
        [self.segmentControl removeAllSegments];
        [viewModels enumerateObjectsUsingBlock:^(RACControllerViewModel *viewModel, NSUInteger index, BOOL *stop) {
            [self.segmentControl insertSegmentWithTitle:viewModel.title atIndex:index animated:NO];
        }];
        self.segmentControl.selectedSegmentIndex = self.viewModel.currentIndex;
        self.segmentControl.frame = CGRectMake(0, 0, viewModels.count * 60, 30);
    }];
    
    RAC(self, currentViewController) = [[RACSignal combineLatest:@[RACObserve(self, viewControllers), RACObserve(self.viewModel, currentIndex)] reduce:^id (NSArray<UIViewController *> *viewControllers, NSNumber *currentIndex){
        if (!viewControllers.count || currentIndex.integerValue >= viewControllers.count) return nil;
        return viewControllers[currentIndex.integerValue];
    }] doNext:^(RACViewController *viewController) {
        if (!viewController) return;
        @strongify(self);
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController removeFromParentViewController];
        [self.currentViewController didMoveToParentViewController:nil];
        
        BOOL isViewLoaded = [viewController isViewLoaded];
        [viewController willMoveToParentViewController:self];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        [self.view addSubview:viewController.view];
        
        if (!isViewLoaded) [self _automaticallyAdjustsScrollViewInsetsForChildViewController:viewController];
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self _automaticallyAdjustsScrollViewInsetsForChildViewController:self.currentViewController];
}

#pragma mark - private

- (void)_automaticallyAdjustsScrollViewInsetsForChildViewController:(UIViewController *)viewController{
    UIView *view = [viewController view];
    UIScrollView *scrollView = [view isKindOfClass:[UIScrollView class]] ? view : [[[view subviews] rac_sequence] objectPassingTest:^BOOL(UIView *view) {
        return [view isKindOfClass:[UIScrollView class]];
    }];
    
    if (@available(iOS 11, *)) {
        if (scrollView.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            scrollView.contentInset = UIEdgeInsetsZero;
        } else {
            UIEdgeInsets inset = self.additionalSafeAreaInsets;
            scrollView.contentInset = inset;
        }
    } else {
        if ([viewController automaticallyAdjustsScrollViewInsets]) {
            UIEdgeInsets inset = self.safeAreaInsets;
            
            scrollView.contentInset = inset;
        } else {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

#pragma mark - accessor

- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    }
    return _segmentControl;
}

- (UIViewController *)topVisibleViewController{
    if (!self.viewControllers.count) return self;
    
    return self.currentViewController.topVisibleViewController;
}

@end
