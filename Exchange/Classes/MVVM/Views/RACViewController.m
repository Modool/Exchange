//
//  RACViewController.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACViewController.h"
#import "RACControllerViewModel.h"
#import "RACDoubleTitleView.h"
#import "RACLoadingTitleView.h"

@interface RACViewController ()

@property (nonatomic, strong) RACControllerViewModel *viewModel;

@end

@implementation RACViewController

- (instancetype)init {
    return [self initWithViewModel:nil];
}

- (instancetype)initWithViewModel:(RACControllerViewModel *)viewModel {
    NSAssert(viewModel, @"View model must be nonull.");
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewModel = viewModel;
        
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeToSubject:viewModel.didLoadViewSignal input:nil];
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeToSubject:viewModel.willAppearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewDidAppear:)] subscribeToSubject:viewModel.didAppearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeToSubject:viewModel.willDisappearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewDidDisappear:)] subscribeToSubject:viewModel.didDisappearSignal input:nil];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    if (@available(iOS 11, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
}

- (void)bindViewModel {
    @weakify(self);
    [[[self viewModel] keyPathAndValues] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        @strongify(self);
        [self setValue:value forKeyPath:key];
    }];
    
    // System title view
    RAC(self, title) = RACObserve([self viewModel], title);
    UIView *titleView = [[self navigationItem] titleView];
    // Double title view
    RACDoubleTitleView *doubleTitleView = [RACDoubleTitleView new];
    RAC([doubleTitleView titleLabel], text)    = RACObserve([self viewModel], title);
    RAC([doubleTitleView subtitleLabel], text) = RACObserve([self viewModel], subtitle);
    [[self rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)] subscribeNext:^(id x) {
        @strongify(self);
        [doubleTitleView titleLabel].text    = [[self viewModel] title];
        [doubleTitleView subtitleLabel].text = [[self viewModel] subtitle];
    }];
    // Loading title view
    RACLoadingTitleView *loadingTitleView = [[RACLoadingTitleView alloc] initWithLoadingText:[[self viewModel] title]];
    @weakify(doubleTitleView);
    @weakify(loadingTitleView);
    RAC(self.navigationItem, titleView) = [[RACObserve([self viewModel], titleViewType) distinctUntilChanged] map:^(NSNumber *value) {
        @strongify(doubleTitleView);
        @strongify(loadingTitleView);
        RACTitleViewType titleViewType = [value unsignedIntegerValue];
        switch (titleViewType) {
            case RACTitleViewTypeDefault:
                return titleView;
            case RACTitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case RACTitleViewTypeLoadingTitle:
                return (UIView *)loadingTitleView;
        }
    }];
    [[[self viewModel] errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD showText:error.localizedDescription inView:self.view];
    }];
}

- (void)dealloc {
    self.viewModel = nil;
}

- (UIEdgeInsets)safeAreaInsets{
//    CGFloat statusBarHeigt = UIApplication.sharedApplication.statusBarHidden ? 0 : CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
//    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : CGRectGetHeight(self.navigationController.navigationBar.frame);
//
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    CGFloat tabBarHeight = tabBar ? (tabBar.isHidden ? 0 : CGRectGetHeight(tabBar.frame)) : 0;
//    CGFloat toolBarHeight = self.navigationController.toolbarHidden ? 0 : CGRectGetHeight(self.navigationController.toolbar.frame);

    CGFloat top = self.topLayoutGuide.length;
    CGFloat bottom = self.bottomLayoutGuide.length;
    
    return UIEdgeInsetsMake(top, 0, bottom, 0);
}

@end
