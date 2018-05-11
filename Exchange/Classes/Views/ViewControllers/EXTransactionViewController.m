//
//  EXTransactionViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTransactionViewController.h"
#import "EXTransactionViewModel.h"
#import "EXProductItemViewModel.h"

#import "NSArray+EXAdditions.h"

#import "EXSocketManager.h"

@interface EXTransactionViewController ()

@property (nonatomic, strong, readonly) EXTransactionViewModel *viewModel;

@end

@implementation EXTransactionViewController
@dynamic viewModel;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.requestDataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray<EXProduct *> *products) {
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        
        NSArray<EXProductItemViewModel *> *viewModels = [self.viewModel viewModelsWithProducts:products];
        section.viewModels = [section.viewModels ?: @[] arrayByAddingObjectsFromArray:viewModels];
        self.viewModel.dataSource = (id)@[section];
        
        [[self tableView] reloadData];
    }];
    
    [[self.viewModel.insertCommand.executionSignals.switchToLatest ignore:nil] subscribeNext:^(EXProductItemViewModel *viewModel) {
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        NSUInteger index = section.viewModels.count;
        
        section.viewModels = [[section viewModels] ?: @[] arrayByAddingObject:viewModel];
        self.viewModel.dataSource = (id)@[section];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [self.viewModel.deleteCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(EXProductItemViewModel *viewModel, NSNumber *animation) = tuple;
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
    
    if (EX_SYSTEM_VERSION < 11) {
        [self.viewModel.collectCommand.executionSignals.switchToLatest subscribeNext:^(EXProductItemViewModel *viewModel) {
            @strongify(self);
            if (!viewModel.collected) return;
            NSIndexPath *indexPath = [[self viewModel] indexPathWithViewModel:viewModel];
            
            if (!indexPath) return;
            [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:EXExchangeDidDoubleClickTabBarItemNotification object:self] mapReplace:self.tableView] subscribeNext:^(UITableView *tableView) {
        NSArray<NSIndexPath *> *indexPaths = [tableView indexPathsForVisibleRows];
        NSUInteger numberOfRows = [tableView numberOfRowsInSection:0] - 1;
        NSUInteger row = [[indexPaths lastObject] row];
        if (row == (numberOfRows - 1)) return;
        
        row = MIN(numberOfRows - 1, row + indexPaths.count);
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self loadMore];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    EXProductItemViewModel *viewModel = [[self viewModel] viewModelAtIndexPath:indexPath];
    
    [EXSocketManager async:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
        [accessor addTickerChannelWithSymbol:viewModel.product.symbol];
    }];
}

@end
