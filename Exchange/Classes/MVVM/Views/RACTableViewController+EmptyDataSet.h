//
//  RACTableViewController+EmptyDataSet.h
//  Exchange
//
//  Created by Jave on 2018/1/6.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RACTableViewController.h"
#import "RACTableViewModel.h"

@interface RACTableViewController (EmptyDataSet)<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong, readonly) RACTableViewModel *viewModel;

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;

@end
