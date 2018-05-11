
//
//  EXMultipleOrderViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXMultipleOrderViewController.h"
#import "EXMultipleOrderViewModel.h"

@interface EXMultipleOrderViewController ()

@property (nonatomic, strong, readonly) EXMultipleOrderViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *hideBarButtonItem;

@end

@implementation EXMultipleOrderViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.hideBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.hideBarButtonItem;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.hideBarButtonItem.rac_command = self.viewModel.selectProductCommand;
    RAC(self.hideBarButtonItem, title) = RACObserve(self.viewModel, rightBarButtonItemTitle);
}


@end
