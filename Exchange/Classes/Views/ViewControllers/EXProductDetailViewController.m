//
//  EXProductDetailViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailViewController.h"
#import "EXProductDetailViewModel.h"

#import "EXProductDetailTickerView.h"

@interface EXProductDetailViewController ()

@property (nonatomic, strong, readonly) EXProductDetailViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *analyseBarButtonItem;

@property (nonatomic, strong) EXProductDetailTickerView *tickerView;

@end

@implementation EXProductDetailViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_star_normal"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.analyseBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[self.analyseBarButtonItem, self.collectBarButtonItem];
    
    self.tickerView = [[EXProductDetailTickerView alloc] init];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tickerView];
    
    [self _installConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

#pragma mark - private

- (void)_installConstraints{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - public

- (void)bindViewModel{
    [super bindViewModel];
    
    [self.tickerView bindViewModel:self.viewModel.tickerViewModel];
    
    self.collectBarButtonItem.rac_command = self.viewModel.collectCommand;
    self.analyseBarButtonItem.rac_command = self.viewModel.analyseCommand;
    
    RAC(self.collectBarButtonItem, image) = [RACObserve(self.viewModel, collected) mapSwitch:@{@NO: [UIImage imageNamed:@"btn_star_normal"], @YES: [UIImage imageNamed:@"btn_star_selected"]}];
}

@end
