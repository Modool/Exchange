//
//  EXUserViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "EXUserViewModel.h"
#import "RACDefaultTableViewController.h"

#import "EXExchangeViewModel.h"
#import "EXExchangeEntranceItemViewModel.h"

#import "EXBalanceViewModel.h"
#import "EXMultipleOrderViewModel.h"
#import "EXEntranceItemViewModel.h"
#import "RACTableSection.h"

#import "EXExchange.h"

#import "EXExchangeEntranceCell.h"
#import "EXEntranceCell.h"

#import "EXConstants.h"
#import "EXMacros.h"

@interface EXUserViewModel ()

@end

@implementation EXUserViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"个人";
        self.style = UITableViewStyleGrouped;
        self.viewControllerClass = EXClass(RACDefaultTableViewController);
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[self title] image:EXImageNamed(@"img_account_n") tag:0];
        self.itemClasses = @{EXClassName(EXExchangeEntranceItemViewModel): EXClass(EXExchangeEntranceCell),
                             EXClassName(EXEntranceItemViewModel): EXClass(EXEntranceCell)};
        
        EXExchange *exchange = [EXExchange exchangeWithDomain:EXExchangeOKExDomain name:@"OKEx"];
        NSMutableArray<RACTableSection *> *sections = [NSMutableArray array];
        
        RACTableSection *section = [[RACTableSection alloc] init];
        section.header = @"交易所";
        section.headerHeight = 40;
        
        RACViewModel *viewModel = [[EXExchangeEntranceItemViewModel alloc] initWithExchange:exchange];
        section.viewModels = @[viewModel];
        [sections addObject:section];
        
        section = [[RACTableSection alloc] init];
        section.headerHeight = 40;
        section.header = @"资产";
        
        viewModel = [[EXEntranceItemViewModel alloc] initWithExchange:exchange];
        section.viewModels = @[viewModel];
        [sections addObject:section];
        
        section = [[RACTableSection alloc] init];
        section.headerHeight = 40;
        section.header = @"订单";
        
        viewModel = [[EXEntranceItemViewModel alloc] initWithExchange:exchange];
        section.viewModels = @[viewModel];
        [sections addObject:section];
        
        self.dataSource = (id)sections;
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        id item = [self viewModelAtIndexPath:indexPath];
        switch (indexPath.section) {
            case 0: [self _transitExchangeWithItem:item]; break;
            case 1: [self _transitBalanceWithItem:item]; break;
            case 2: [self _transitOrderWithItem:item]; break;
            default: break;
        }
        return [RACSignal empty];
    }];
}

#pragma mark - public

- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<EXUserItemViewModel> viewModel = [self viewModelAtIndexPath:indexPath];
    if ([viewModel respondsToSelector:@selector(heightInContentView:)]) return [viewModel heightInContentView:contentView];
    if ([viewModel respondsToSelector:@selector(height)]) return [viewModel height];
    
    return 0;
}

#pragma mark private

- (void)_transitExchangeWithItem:(EXExchangeEntranceItemViewModel *)item{
    NSDictionary *params = @{@keypath(item, exchange): item.exchange};
    EXExchangeViewModel *viewModel = [[EXExchangeViewModel alloc] initWithServices:self.services params:params];
    
    @weakify(self);
    viewModel.callback = ^(EXExchange *exchange) {
        @strongify(self);
        item.exchange = exchange;
        
        [[self services] popViewModelAnimated:YES];
    };
    [[self services] pushViewModel:viewModel animated:YES];
}

- (void)_transitBalanceWithItem:(EXEntranceItemViewModel *)item{
    NSDictionary *params = @{@keypath(item, exchange): item.exchange};
    EXBalanceViewModel *viewModel = [[EXBalanceViewModel alloc] initWithServices:self.services params:params];
    [[self services] pushViewModel:viewModel animated:YES];
}

- (void)_transitOrderWithItem:(EXEntranceItemViewModel *)item{
    NSDictionary *params = @{@"exchange": item.exchange};
    EXMultipleOrderViewModel *viewModel = [[EXMultipleOrderViewModel alloc] initWithServices:self.services params:params];
    [[self services] pushViewModel:viewModel animated:YES];
}

@end
