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
#import "EXProductDetailTradeView.h"
#import "EXProductDetailDepthView.h"

@interface EXProductDetailViewController ()

@property (nonatomic, strong, readonly) EXProductDetailViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;

@property (nonatomic, strong) EXProductDetailTickerView *tickerView;
@property (nonatomic, strong) EXProductDetailTradeView *tradeView;
@property (nonatomic, strong) EXProductDetailDepthView *depthView;

@end

@implementation EXProductDetailViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_star_normal"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.collectBarButtonItem;
    
    self.tickerView = [[EXProductDetailTickerView alloc] init];
    self.tradeView = [[EXProductDetailTradeView alloc] init];
    self.depthView = [[EXProductDetailDepthView alloc] init];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tickerView];
    [self.scrollView addSubview:self.tradeView];
    [self.scrollView addSubview:self.depthView];
    
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
        make.left.top.right.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.tradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollView);
        make.top.equalTo(self.tickerView.mas_bottom);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
    
    [self.depthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.top.equalTo(self.tradeView.mas_bottom);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
}

#pragma mark - public

- (void)bindViewModel{
    [super bindViewModel];
    
    [self.tickerView bindViewModel:self.viewModel.tickerViewModel];
    [self.tradeView bindViewModel:self.viewModel.tradeViewModel];
    
    self.collectBarButtonItem.rac_command = self.viewModel.collectCommand;
    RAC(self.collectBarButtonItem, image) = [RACObserve(self.viewModel, collected) mapSwitch:@{@NO: [UIImage imageNamed:@"btn_star_normal"], @YES: [UIImage imageNamed:@"btn_star_selected"]}];
}

@end
