//
//  EXProductDetailViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailViewModel.h"
#import "EXProductDetailViewController.h"

#import "EXProductManager.h"
#import "EXSocketManager.h"

@interface EXProductDetailViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) EXProductDetailTickerViewModel *tickerViewModel;
@property (nonatomic, strong) EXProductDetailTradeViewModel *tradeViewModel;
@property (nonatomic, strong) EXProductDetailDepthViewModel *depthViewModel;

@property (nonatomic, strong) RACCommand *collectCommand;

@property (nonatomic, copy) NSArray<EXTrade *> *trades;

@property (nonatomic, copy) NSArray<EXTrade *> *buyTrades;
@property (nonatomic, copy) NSArray<EXTrade *> *sellTrades;

@end

@implementation EXProductDetailViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        
        __block BOOL collected = NO;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            collected = [accessor isCollectedProductForSymbol:self->_product.symbol];
        }];
        _collected = collected;
        
        self.trades = _product.trades;
        self.title = _product.normalizedSymbol.uppercaseString;
        self.viewControllerClass = EXClass(EXProductDetailViewController);
        self.tradeViewModel = [[EXProductDetailTradeViewModel alloc] init];
        self.depthViewModel = [[EXProductDetailDepthViewModel alloc] init];
        self.tickerViewModel = [[EXProductDetailTickerViewModel alloc] initWithProduct:_product exchange:_exchange];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.collectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self collectSignalWithProduct:self.product collected:!self.collected];
    }];
    
    RAC(self, collected) = [self.collectCommand.executionSignals.switchToLatest reduceTake:2];
    
    [self.collectCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if (self.collection) self.collection(tuple.first, [tuple.second boolValue]);
    }];
    
    RAC(self.tradeViewModel, buyTrades) = RACObserve(self, buyTrades);
    RAC(self.tradeViewModel, sellTrades) = RACObserve(self, sellTrades);
    
    [RACObserve(self, trades) subscribeNext:^(NSArray<EXTrade *> *trades) {
        @strongify(self);
        NSMutableArray<EXTrade *> *buyTrades = [NSMutableArray array];
        NSMutableArray<EXTrade *> *sellTrades = [NSMutableArray array];
        
        for (EXTrade *trade in trades) {
            NSMutableArray *mutableTrades = trade.buy ? buyTrades : sellTrades;
            [mutableTrades addObject:trade];
        }
        
        self.buyTrades = buyTrades;
        self.sellTrades = sellTrades;
    }];
    
    [self.didAppearSignal subscribeToTarget:self performSelector:@selector(_registerChannel)];
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    [self _registerDelegate];
}

#pragma mark - private

- (void)_registerDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor addDelegate:self delegateQueue:dispatch_get_main_queue() forSymbol:self.product.symbol];
    }];
}

- (void)_deregisterDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor removeDelegate:self delegateQueue:dispatch_get_main_queue() forSymbol:self.product.symbol];
    }];
}

- (void)_registerChannel{
    [EXSocketManager sync:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
        [accessor addTradeChannelWithSymbol:self.product.symbol];
    }];
}

#pragma mark - signal

- (RACSignal *)collectSignalWithProduct:(EXProduct *)product collected:(BOOL)collected{
    return [RACSignal defer:^RACSignal *{
        __block BOOL state = NO;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            state = collected ? [accessor collectProductWithSymbol:product.symbol] : [accessor descollectProductWithSymbol:product.symbol];
        }];
        return [RACSignal return:RACTuplePack(product, @(collected))];
    }];
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager didAppendTrades:(NSArray<EXTrade *> *)trades forSymbol:(NSString *)symbol;{
    NSMutableArray<EXTrade *> *buyTrades = [NSMutableArray array];
    NSMutableArray<EXTrade *> *sellTrades = [NSMutableArray array];
    
    for (EXTrade *trade in trades) {
        NSMutableArray *mutableTrades = trade.buy ? buyTrades : sellTrades;
        [mutableTrades addObject:trade];
    }
    
    if (buyTrades.count) {
        self.buyTrades = [self.buyTrades ?: @[] arrayByAddingObjectsFromArray:buyTrades];
    }
    
    if (sellTrades.count) {
        self.sellTrades = [self.sellTrades ?: @[] arrayByAddingObjectsFromArray:sellTrades];
    }
}

@end
