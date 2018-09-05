//
//  EXSearchProductViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/28.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSearchProductViewController.h"
#import "EXSearchProductViewModel.h"

@interface EXSearchProductViewController ()<UISearchBarDelegate>

@property (nonatomic, strong, readonly) EXSearchProductViewModel *viewModel;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation EXSearchProductViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"关键字";
    
    self.navigationItem.titleView = self.searchBar;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    RACSignal *textSignal = [self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)];
    RACSignal *searchSignal = [self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)];
    
    RAC(self.viewModel, keyword) = [textSignal reduceTake:2];
    
    [[[RACSignal merge:@[textSignal, searchSignal]] mapReplace:self.viewModel] subscribeNext:^(EXSearchProductViewModel *viewModel) {
        viewModel.dataSource = nil;
        [viewModel.requestDataCommand execute:@1];
    }];
    
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        UIScrollView *scrollView = tuple.first;
        [scrollView endEditing:YES];
    }];
}

@end
