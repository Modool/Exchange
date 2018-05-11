//
//  RACDefaultTableViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACDefaultTableViewController.h"

@interface RACDefaultTableViewController ()

@end

@implementation RACDefaultTableViewController

- (void)bindViewModel{
    [super bindViewModel];
    
    [RACObserve(self.viewModel, dataSource) subscribeToTarget:self.tableView performSelector:@selector(reloadData)];
}

@end
