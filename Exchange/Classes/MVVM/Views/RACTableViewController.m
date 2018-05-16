//
//  RACTableViewController.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>

#import "RACTableViewController.h"
#import "RACTableViewController+EmptyDataSet.h"
#import "RACTableViewModel.h"
#import "RACDoubleTitleView.h"
#import "RACLoadingTitleView.h"
#import "RACTableSection.h"

#define EXTableViewUpdate(handler)  \
{                                       \
    [[self tableView] beginUpdates];    \
    handler;                            \
    [[self tableView] endUpdates];      \
}

@interface RACTableViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation RACTableViewController
@dynamic viewModel;

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [self initWithViewModel:nil];
}

- (instancetype)initWithViewModel:(RACTableViewModel *)viewModel {
    NSAssert(viewModel, @"View model must be nonull.");
    self = [super initWithViewModel:viewModel];
    if (self) {
        @weakify(viewModel);
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(viewModel);            
            if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
                [[viewModel requestDataCommand] execute:@1];
            }
        }];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    if (!_tableView) {
        self.view = [self tableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.tableView.rowHeight = self.viewModel.rowHeight;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;
    self.tableView.tableFooterView = [UIView new];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    @weakify(self);
    if ([[self viewModel] shouldPullToRefresh]) {
        self.tableView.refreshControl = [UIRefreshControl new];
        
        [[[[self tableView] refreshControl] rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIControl *x) {
            @strongify(self);
            [self didTriggerRefresh];
        }];
    }
    if ([[self viewModel] shouldPullToLoadMore]) {
        [[self tableView] addInfiniteScrollingWithActionHandler:^{
            @strongify(self);
            [self didTriggerLoadMore];
        }];
    }
}

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
    self.tableView = nil;
}

#pragma mark - accessor

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:[[self viewModel] style]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (void)setView:(UIView *)view {
    [super setView:view];
    if ([view isKindOfClass:UITableView.class]) {
        self.tableView = (UITableView *)view;
    }
}

#pragma mark - protected

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [RACObserve([self viewModel], footerHeaderItemClasses) subscribeNext:^(NSDictionary<Class, Class<RACView, NSObject>> *itemClasses) {
        @strongify(self);
        for (Class<RACView, NSObject> class in [itemClasses allValues]) {
            [[self tableView] registerClass:class forHeaderFooterViewReuseIdentifier:NSStringFromClass(class)];
        }
    }];
    
    [RACObserve([self viewModel], itemClasses) subscribeNext:^(NSDictionary<Class, Class<RACView, NSObject>> *itemClasses) {
        @strongify(self);
        for (Class<RACView, NSObject> class in [itemClasses allValues]) {
            [[self tableView] registerClass:class forCellReuseIdentifier:NSStringFromClass(class)];
        }
    }];
    
    [[[[self viewModel] requestDataCommand] executing] subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        UIView *emptyDataSetView = [[[[self tableView] subviews] rac_sequence] objectPassingTest:^(UIView *view) {
            return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
        }];
        emptyDataSetView.alpha = 1.0 - [executing floatValue];
    }];
    
    if (self.viewModel.shouldPullToRefresh) {
        [[self.viewModel rac_signalForSelector:@selector(refresh)] subscribeToTarget:self performSelector:@selector(refresh)];
    }
    
    if ([[self viewModel] shouldPullToLoadMore]) {
        RAC([self tableView], showsInfiniteScrolling) = [RACObserve([self viewModel], loadMoreEnabled) deliverOnMainThread];
        [[self.viewModel rac_signalForSelector:@selector(loadMore)] subscribeToTarget:self performSelector:@selector(loadMore)];
    }
}

#pragma mark - public

- (void)reloadData {
    [[self tableView] reloadData];
}

- (void)refresh;{
    [self didTriggerRefresh];
}

- (void)loadMore;{
    [self didTriggerLoadMore];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self viewModel] dataSource] ?: @[] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<RACTableSection> tableSection = self.viewModel.dataSource[section];
    return [[tableSection viewModels] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self viewModel] sectionIndexTitles];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;{
    return [[self viewModel] allowEditAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RACViewModel *viewModel = [[self viewModel] viewModelAtIndexPath:indexPath];
    if (!viewModel) return nil;

    Class<RACView, NSObject> class = [[self viewModel] classForViewModel:viewModel];
    if (!class) return nil;
    
    UITableViewCell<RACView> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(class)];
    if (!cell) return nil;
    
    [cell bindViewModel:viewModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel contentView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self viewModel] rowEditActionsAtIndexPath:indexPath];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSArray *actions = [[self viewModel] leadingSwipeActionsForRowAtIndexPath:indexPath] ?: @[];
    
    return [[self viewModel] leadingSwipeConfigurationWithActions:actions];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSArray *actions = [[self viewModel] trailingSwipeActionsForRowAtIndexPath:indexPath] ?: @[];
    
    return [[self viewModel] trailingSwipeConfigurationWithActions:actions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id<RACTableSection> tableSection = self.viewModel.dataSource[section];
    
    return [tableSection headerHeight] > 0 ? [tableSection headerHeight] : 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    RACTableSection<RACTableSection> *tableSection = self.viewModel.dataSource[section];
    
    return [tableSection header];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RACTableSection<RACTableSection> *tableSection = self.viewModel.dataSource[section];
    if (!tableSection || ![tableSection headerViewClass]) return nil;
    
    UITableViewHeaderFooterView<RACView> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([tableSection headerViewClass])];
    if (!view) return nil;
    
    [view bindViewModel:tableSection];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    RACTableSection<RACTableSection> *tableSection = self.viewModel.dataSource[section];
    
    return [tableSection footerHeight] > 0 ? [tableSection footerHeight] : 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    id<RACTableSection> tableSection = self.viewModel.dataSource[section];
    
    return [tableSection footer];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    RACTableSection<RACTableSection> *tableSection = self.viewModel.dataSource[section];
    if (!tableSection || ![tableSection footerViewClass]) return nil;
    
    UITableViewHeaderFooterView<RACView> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([tableSection footerViewClass])];
    if (!view) return nil;
    
    [view bindViewModel:tableSection];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    return [[self viewModel] allowSelectAtIndexPath:indexPath] ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.snapshot = [[[self navigationController] view] snapshotViewAfterScreenUpdates:NO];
        [[[self viewModel] didSelectCommand] execute:indexPath];
    });
}

#pragma mark - actions

- (IBAction)didTriggerRefresh{
    [[[self tableView] infiniteScrollingView] stopAnimating];
    @weakify(self);
    [[[[[self viewModel] requestDataCommand] execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.page = 1;
        self.viewModel.dataSource = nil;
    } error:^(NSError *error) {
        @strongify(self);
        [[[self tableView] refreshControl] endRefreshing];
    }  completed:^{
        @strongify(self);
        [[[self tableView] refreshControl] endRefreshing];
    }];
}

- (IBAction)didTriggerLoadMore{
    [[[self tableView] refreshControl] endRefreshing];
    @weakify(self);
    [[[[[self viewModel] requestDataCommand] execute:@([[self viewModel] page] + 1)] deliverOnMainThread] subscribeNext:^(NSArray *results) {
        @strongify(self);
        [self viewModel].page += 1;
    } error:^(NSError *error) {
        @strongify(self);
        [[[self tableView] infiniteScrollingView] stopAnimating];
    }  completed:^{
        @strongify(self);
        [[[self tableView] infiniteScrollingView] stopAnimating];
    }];
}

@end
