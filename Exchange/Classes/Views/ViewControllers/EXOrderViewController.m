
//
//  EXOrderViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOrderViewController.h"
#import "EXOrderViewModel.h"
#import "RACTableSection.h"

#import "NSArray+EXAdditions.h"

@interface EXOrderViewController ()

@property (nonatomic, strong, readonly) EXOrderViewModel *viewModel;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation EXOrderViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    self.tipsLabel.text = @"* 只能查看最近两天的订单";
    self.tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel.textColor = [UIColor redColor];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    if (self.viewModel.finished) self.tableView.tableHeaderView = self.tipsLabel;
    
    [self.viewModel.requestDataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray<EXOrder *> *orders) {
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        
        NSArray<EXOrderItemViewModel *> *viewModels = [self.viewModel viewModelsWithOrders:orders];
        section.viewModels = [section.viewModels ?: @[] arrayByAddingObjectsFromArray:viewModels];
        self.viewModel.dataSource = (id)@[section];
        
        [[self tableView] reloadData];
    }];
    
    [[self.viewModel.insertCommand.executionSignals.switchToLatest ignore:nil] subscribeNext:^(EXOrderItemViewModel *viewModel) {
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        NSUInteger index = section.viewModels.count;
        
        section.viewModels = [[section viewModels] ?: @[] arrayByAddingObject:viewModel];
        self.viewModel.dataSource = (id)@[section];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [self.viewModel.deleteCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(EXOrderItemViewModel *viewModel, NSNumber *animation) = tuple;
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        NSUInteger row = [[section viewModels] indexOfObject:viewModel];
        if (row == NSNotFound) {
            self.viewModel.dataSource = (id)@[section];
        } else {
            section.viewModels = [[section viewModels] ?: @[] arrayByRemovingObject:viewModel];
            
            self.viewModel.dataSource = (id)@[section];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation.integerValue];
        }
    }];
}

@end
