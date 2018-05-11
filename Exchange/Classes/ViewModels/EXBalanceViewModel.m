

//
//  EXBalanceViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalanceViewModel.h"
#import "EXBalanceViewController.h"
#import "EXBalanceViewModel.h"

#import "EXHTTPClient.h"
#import "EXProductManager.h"

#import "EXExchange.h"
#import "EXBalance.h"
#import "EXProduct.h"

#import "RACTableSection.h"
#import "EXBalanceCell.h"

@interface EXBalanceViewModel ()

@property (nonatomic, strong) id<EXHTTPClient> client;

@property (nonatomic, strong) RACCommand *hideCommand;

@property (nonatomic, assign) BOOL hide;

@end

@implementation EXBalanceViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _exchange = params[@keypath(self, exchange)];
        self.title = _exchange.name;
        self.client = _exchange.client;
        
        self.rowHeight = 60;
        self.style = UITableViewStyleGrouped;
        self.viewControllerClass = EXClass(EXBalanceViewController);
        self.itemClasses = @{EXClassName(EXBalanceItemViewModel): EXClass(EXBalanceCell)};
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.hideCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:@(!self.hide)];
    }];
    
    RAC(self, hide) = self.hideCommand.executionSignals.switchToLatest;
    RAC(self, rightBarButtonItemTitle) = [RACObserve(self, hide) map:^id(NSNumber *hide) {
        return hide.boolValue ? @"显示" : @"隐藏";
    }];
    
    RAC(self, viewModels) = [self.requestDataCommand.executionSignals.switchToLatest map:^id(NSArray<EXBalance *> *balances) {
        @strongify(self);
        return [self viewModelsWithBalances:balances];
    }];
    
    RAC(self, dataSource) = [RACSignal combineLatest:@[RACObserve(self, viewModels), RACObserve(self, hide)] reduce:^id(NSArray<EXBalanceItemViewModel *> *viewModels, NSNumber *hide){
        NSArray<EXBalanceItemViewModel *> *(^filter)(NSArray<EXBalanceItemViewModel *> *_viewModels) = ^NSArray<EXBalanceItemViewModel *> *(NSArray<EXBalanceItemViewModel *> *_viewModels){
            return [[_viewModels.rac_sequence filter:^BOOL(EXBalanceItemViewModel *viewModel) {
                return viewModel.all > 0;
            }] array];
        };
        RACTableSection *section = [[RACTableSection alloc] init];
        section.viewModels = hide.boolValue ? filter(viewModels) : viewModels;
        return @[section];
    }];
    
    [self.requestDataCommand.errors subscribe:self.errors];
}

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    return [[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXBalance *> *balances = [accessor balances];
            
            [[[RACSignal return:balances] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] setNameWithFormat:RACSignalDefaultNameFormat];
}

- (NSArray<EXBalanceItemViewModel *> *)viewModelsWithBalances:(NSArray<EXBalance *> *)balances;{
    @weakify(self);
    NSArray<NSString *> *symbols = EXProduct.sortedFromSymbols.copy;
    return [[[[balances rac_sequence] map:^id(EXBalance *balance){
        @strongify(self);
        return [self viewModelWithBalance:balance];
    }] array] sortedArrayUsingComparator:^NSComparisonResult(EXBalanceItemViewModel *item1, EXBalanceItemViewModel *item2) {
        NSUInteger index1 = [symbols indexOfObject:item1.symbol];
        NSUInteger index2 = [symbols indexOfObject:item2.symbol];
        
        if (index1 != NSNotFound || index2 != NSNotFound) {
            if (index1 == NSNotFound) return NSOrderedDescending;
            if (index2 == NSNotFound) return NSOrderedAscending;
            if (index1 > index2) return NSOrderedDescending;
            if (index1 < index2) return NSOrderedAscending;
        }
        
        if (item2.all == 0) return NSOrderedAscending;
        if (item1.all == 0) return NSOrderedDescending;
        if (item1.all < item2.all) return NSOrderedDescending;
        else return NSOrderedAscending;
    }];
}

- (EXBalanceItemViewModel *)viewModelWithBalance:(EXBalance *)balance;{
    return [[EXBalanceItemViewModel alloc] initWithBalance:balance];
}

@end
