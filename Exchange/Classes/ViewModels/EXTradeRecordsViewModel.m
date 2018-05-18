//
//  EXTradeRecordsViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeRecordsViewModel.h"
#import "EXTradeRecordsViewController.h"

#import "EXCommissionViewModel.h"

#import "EXProductManager.h"
#import "EXSocketManager.h"

#import "RACTableSection.h"
#import "EXTradeItemViewModel.h"
#import "EXTradeCell.h"

@interface EXTradeRecordsViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) RACCommand *depthCommand;

@end

@implementation EXTradeRecordsViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        
        self.title = @"成交量";
        self.rowHeight = 30;
        self.viewControllerClass = EXClass(EXTradeRecordsViewController);
        self.itemClasses = @{EXClassName(EXTradeItemViewModel): EXClass(EXTradeCell)};
    }
    return self;
}


- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.depthCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        EXCommissionViewModel *viewModel = [[EXCommissionViewModel alloc] initWithServices:self.services params:@{@keypath(self, product): self.product, @keypath(self, exchange): self.exchange}];
        [[self services] pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];

    [self.didAppearSignal subscribeToTarget:self performSelector:@selector(_registerChannel)];
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    
    [self _registerDelegate];
}

#pragma mark - private

- (void)_registerDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor addDelegate:self delegateQueue:dispatch_get_main_queue() forProductID:self.product.objectID];
    }];
}

- (void)_deregisterDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor removeDelegate:self delegateQueue:dispatch_get_main_queue() forProductID:self.product.objectID];
    }];
}

- (void)_registerChannel{
    [EXSocketManager sync:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
        [accessor addTradeChannelWithSymbol:self.product.symbol];
    }];
}

//
//- (void)_appendTrades:(NSArray<EXTrade *> *)trades buys:(NSArray<EXTradeSet *> *)buys sells:(NSArray<EXTradeSet *> *)sells{
//    NSMutableArray<EXTradeSet *> *mutableBuys = [NSMutableArray arrayWithArray:buys ?: @[]];
//    NSMutableArray<EXTradeSet *> *mutableSells = [NSMutableArray arrayWithArray:sells ?: @[]];
//
//    for (EXTrade *trade in trades) {
//        NSMutableArray<EXTradeSet *> *mutableSets = trade.buy ? mutableBuys : mutableSells;
//        EXTradeSet *tradeSet = [self tradeSetByPrice:trade.price inSets:mutableSets.copy];
//        if (tradeSet) {
//            tradeSet.amount += trade.amount;
//            tradeSet.count++;
//        } else {
//            tradeSet = [EXTradeSet setWithPrice:trade.price buy:trade.buy amount:trade.amount count:1];
//            [mutableSets addObject:tradeSet];
//        }
//    }
//    [mutableBuys sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(EXTradeSet *set1, EXTradeSet *set2) {
//        return set1.price < set2.price;
//    }];
//
//    [mutableSells sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(EXTradeSet *set1, EXTradeSet *set2) {
//        return set1.price > set2.price;
//    }];
//
//    buys = mutableBuys.count > 10 ? [mutableBuys subarrayWithRange:NSMakeRange(0, 10)] : mutableBuys.copy;
//    sells = mutableSells.count > 10 ? [mutableSells subarrayWithRange:NSMakeRange(0, 10)] : mutableSells.copy;
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.buys = buys;
//        self.sells = sells;
//    });
//}
//
//- (EXTradeSet *)tradeSetByPrice:(double)price inSets:(NSArray<EXTradeSet *> *)sets{
//    __block EXTradeSet *result = nil;
//    [sets enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(EXTradeSet *set, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (set.price == price) {
//            result = set;
//            *stop = YES;
//        }
//    }];
//    return result;
//}

- (NSArray<EXTradeItemViewModel *> *)viewModelsWithTrades:(NSArray<EXTrade *> *)trades{
    return [[[trades rac_sequence] map:^id(EXTrade *trade) {
        return [self viewModelWithTrade:trade];
    }] array];
}

- (EXTradeItemViewModel *)viewModelWithTrade:(EXTrade *)trade{
    return [[EXTradeItemViewModel alloc] initWithTrade:trade];
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didAppendTrades:(NSArray<EXTrade *> *)trades;{
    id<RACTableSection> section = self.dataSource.firstObject ?: [[RACTableSection alloc] init];
    NSArray<EXTradeItemViewModel *> *viewModels = section.viewModels ?: @[];
    
    viewModels = [[self viewModelsWithTrades:trades] arrayByAddingObjectsFromArray:viewModels];
    section.viewModels = viewModels;
    
    self.dataSource = (id)@[section];
}

@end
