//
//  EXProductDetailViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailViewModel.h"
#import "EXProductDetailViewController.h"

#import "EXTradeRecordsViewModel.h"

#import "EXProductManager.h"
#import "EXSocketManager.h"

@interface EXProductDetailViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) EXProductDetailTickerViewModel *tickerViewModel;

@property (nonatomic, strong) RACCommand *collectCommand;
@property (nonatomic, strong) RACCommand *analyseCommand;

@end

@implementation EXProductDetailViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        _collected = _product.collected;
        
        self.title = _product.normalizedSymbol.uppercaseString;
        self.viewControllerClass = EXClass(EXProductDetailViewController);
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
    
    self.analyseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        EXTradeRecordsViewModel *viewModel = [[EXTradeRecordsViewModel alloc] initWithServices:self.services params:@{@keypath(viewModel, product): self.product, @keypath(viewModel, exchange): self.exchange}];
        
        [[self services] pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
    RAC(self, collected) = [self.collectCommand.executionSignals.switchToLatest reduceTake:2];
    
    [self.collectCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if (self.collection) self.collection(tuple.first, [tuple.second boolValue]);
    }];
    
    [self.didAppearSignal subscribeToTarget:self performSelector:@selector(_registerChannel)];
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    
    [self _registerDelegate];
}

#pragma mark - private

- (void)_registerDelegate{
//    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
//        [accessor addDelegate:self delegateQueue:self.queue forProductID:self.product.objectID];
//    }];
}

- (void)_deregisterDelegate{
//    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
//        [accessor removeDelegate:self delegateQueue:self.queue forProductID:self.product.objectID];
//    }];
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
            state = [accessor updateProductByID:product.objectID collected:collected];
        }];
        return [RACSignal return:RACTuplePack(product, @(collected))];
    }];
}

@end
