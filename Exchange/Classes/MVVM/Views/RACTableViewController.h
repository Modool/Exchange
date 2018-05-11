//
//  RACTableViewController.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RACViewController.h"
#import "RACTableViewModel.h"

@interface RACTableViewController : RACViewController<RACViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong, readonly) RACTableViewModel *viewModel;

// The table view for tableView controller.
@property (nonatomic, strong, readonly) UITableView *tableView;

- (instancetype)initWithViewModel:(RACTableViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

- (void)refresh;
- (void)loadMore;

@end
