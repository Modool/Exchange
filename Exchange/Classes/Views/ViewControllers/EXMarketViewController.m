//
//  EXMarketViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/28.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXMarketViewController.h"
#import "EXMarketViewModel.h"

@interface EXMarketViewController ()

@property (nonatomic, strong, readonly) EXMarketViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@end

@implementation EXMarketViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.rightBarButtonItem.rac_command = self.viewModel.searchCommand;
}

@end
