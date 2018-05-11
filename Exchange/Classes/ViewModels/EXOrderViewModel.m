
//
//  EXOrderViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOrderViewModel.h"
#import "EXOrderViewController.h"

#import "EXOrderItemViewModel.h"
#import "EXUnfinishedOrderItemViewModel.h"

#import "EXOrderCell.h"
#import "EXUnfinishedOrderCell.h"

#import "EXExchange.h"
#import "EXHTTPClient.h"

@interface EXOrderViewModel ()

@property (nonatomic, strong) id<EXHTTPClient> client;

@property (nonatomic, strong) EXExchange *exchange;

@property (nonatomic, strong) EXProduct *product;

@end

@implementation EXOrderViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _finished = [params[@keypath(self, finished)] boolValue];
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        _client = _exchange.client;
        
        self.perPage = 5;
        self.title = _product.symbol;
        self.shouldPullToRefresh = YES;
        self.shouldPullToLoadMore = YES;
        self.viewControllerClass = EXClass(EXOrderViewController);
        if (_finished) {
            self.itemClasses = @{EXClassName(EXOrderItemViewModel): EXClass(EXOrderCell)};
        } else {
            self.itemClasses = @{EXClassName(EXUnfinishedOrderItemViewModel): EXClass(EXUnfinishedOrderCell)};
        }
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    RAC(self, loadMoreEnabled) = [self.requestDataCommand.executionSignals.switchToLatest.mapArrayCount map:^id(NSNumber *value) {
        @strongify(self);
        return @(value.integerValue >= self.perPage);
    }];
    
    [RACObserve(self, product) subscribeToTarget:self performSelector:@selector(refresh)];
    [self.requestDataCommand.errors subscribe:self.errors];
}

#pragma mark - signal accessor

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    return [[[self client] fetchHistoryOrdersWithSymbol:self.product.symbol finished:self.finished page:page size:self.perPage] collect];
}

#pragma mark - transformer

- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EXOrderItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    return [viewModel isKindOfClass:[EXUnfinishedOrderItemViewModel class]] ? 130 : 180;
}

- (NSArray<EXOrderItemViewModel *> *)viewModelsWithOrders:(NSArray<EXOrder *> *)orders;{
    @weakify(self);
    return [[[orders rac_sequence] map:^id (EXOrder *order) {
        @strongify(self);
        return [self viewModelWithOrder:order];
    }] array];
}

- (EXOrderItemViewModel *)viewModelWithOrder:(EXOrder *)order;{
    if ([order status] != EXOrderStatusUnsettled && [order status] != EXOrderStatusPartUnsettled) return [EXOrderItemViewModel viewModelWithOrder:order];
    return [EXUnfinishedOrderItemViewModel viewModelWithOrder:order];
}

@end
