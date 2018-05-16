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

#import "EXTradeSet.h"

@interface EXProductDetailViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) EXProductDetailTickerViewModel *tickerViewModel;
@property (nonatomic, strong) EXProductDetailTradeViewModel *tradeViewModel;
@property (nonatomic, strong) EXProductDetailDepthViewModel *depthViewModel;

@property (nonatomic, strong) RACCommand *collectCommand;

@property (nonatomic, copy) NSArray<EXTradeSet *> *buyTrades;
@property (nonatomic, copy) NSArray<EXTradeSet *> *sellTrades;

@end

@implementation EXProductDetailViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        _collected = _product.collected;
        
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

- (void)_updateTradeSet:(EXTradeSet *)tradeSet{
//    NSArray<EXTradeSet *> *trades = tradeSet.buy ? self.buyTrades : self.sellTrades;
//    NSDictionary<NSNumber *, EXTradeSet *> *tradeDictionary = tradeSet.buy ? self.buyTradeDictionary : self.sellTradeDictionary;
//    
//    NSMutableArray<EXTradeSet *> *mutableTrades = [trades ?: @[] mutableCopy];
//    NSMutableDictionary<NSNumber *, EXTradeSet *> *mutableTradeDictionary = [tradeDictionary ?: @{} mutableCopy];
//    
//    EXTradeSet *local = tradeDictionary[@(tradeSet.price)];
//    if (local) {
//        NSUInteger index = [trades indexOfObject:tradeSet];
//        if (index != NSNotFound) {
//            [mutableTrades replaceObjectAtIndex:index withObject:tradeSet];
//        } else {
//            [mutableTrades addObject:tradeSet];
//            [mutableTrades sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(EXTradeSet *trade1, EXTradeSet *trade2) {
//                return tradeSet.buy && trade1.price > trade2.price;
//            }];
//        }
//    } else {
//        [mutableTrades addObject:tradeSet];
//        [mutableTrades sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(EXTradeSet *trade1, EXTradeSet *trade2) {
//            return tradeSet.buy && trade1.price > trade2.price;
//        }];
//    }
//    mutableTradeDictionary[@(tradeSet.price)] = tradeSet;
//    
//    if (tradeSet.buy) {
//        self.buyTrades = mutableTrades.copy;
//        self.buyTradeDictionary = mutableTradeDictionary.copy;
//    } else {
//        self.sellTrades = mutableTrades.copy;
//        self.sellTradeDictionary = mutableTradeDictionary.copy;
//    }
}

#pragma mark - signal

- (RACSignal *)collectSignalWithProduct:(EXProduct *)product collected:(BOOL)collected{
    return [RACSignal defer:^RACSignal *{
        __block BOOL state = NO;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            state = [accessor updateProductByID:product.objectID collected:collected];
        }];
        return [RACSignal return:RACTuplePack(product, @(collected))];
    }];
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager didUpdateTradeSet:(EXTradeSet *)tradeSet forSymbol:(NSString *)symbol;{
    [self _updateTradeSet:tradeSet];
}

- (void)productManager:(EXProductManager *)productManager didAppendTradeSet:(EXTradeSet *)tradeSet forSymbol:(NSString *)symbol;{
    [self _updateTradeSet:tradeSet];
}

@end
