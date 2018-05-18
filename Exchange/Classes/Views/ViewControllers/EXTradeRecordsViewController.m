//
//  EXTradeRecordsViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeRecordsViewController.h"
#import "EXTradeRecordsViewModel.h"

@interface EXTradeRecordsViewController ()

@property (nonatomic, strong, readonly) EXTradeRecordsViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *depthBarButtonItem;

@end

@implementation EXTradeRecordsViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.depthBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"委托量" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.depthBarButtonItem;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.depthBarButtonItem.rac_command = self.viewModel.depthCommand;
}

@end
