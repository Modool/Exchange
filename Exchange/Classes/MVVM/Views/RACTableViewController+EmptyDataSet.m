//
//  RACTableViewController+EmptyDataSet.m
//  Exchange
//
//  Created by Jave on 2018/1/6.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACTableViewController+EmptyDataSet.h"

@implementation RACTableViewController (EmptyDataSet)
@dynamic viewModel;

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UITableView *)tableView {
    return -(self.tableView.contentInset.top - self.tableView.contentInset.bottom) / 2;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return [[[self viewModel] dataSource] ?: @[] count];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
