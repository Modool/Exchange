//
//  EXBalanceViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalanceViewController.h"
#import "EXBalanceViewModel.h"

@interface EXBalanceViewController ()

@property (nonatomic, strong, readonly) EXBalanceViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *hideBarButtonItem;

@end

@implementation EXBalanceViewController
@dynamic viewModel;

- (instancetype)initWithViewModel:(EXBalanceViewModel *)viewModel{
    if (self = [super initWithViewModel:viewModel]) {
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeToCommand:viewModel.requestDataCommand input:nil];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.hideBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.hideBarButtonItem;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.hideBarButtonItem.rac_command = self.viewModel.hideCommand;
    RAC(self.hideBarButtonItem, title) = RACObserve(self.viewModel, rightBarButtonItemTitle);
    
    [RACObserve(self.viewModel, dataSource) subscribeToTarget:self.tableView performSelector:@selector(reloadData)];
}


@end
