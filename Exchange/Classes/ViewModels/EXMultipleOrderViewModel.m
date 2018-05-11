
//
//  EXMultipleOrderViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXMultipleOrderViewModel.h"
#import "EXMultipleOrderViewController.h"

#import "EXOrderViewModel.h"
#import "EXProductViewModel.h"

#import "EXProductManager.h"
#import "EXProduct.h"

@interface EXMultipleOrderViewModel()

@property (nonatomic, strong) RACCommand *selectProductCommand;

@property (nonatomic, strong) EXExchange *exchange;

@property (nonatomic, strong) EXProduct *product;

@end

@implementation EXMultipleOrderViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"订单";
        self.exchange = params[@keypath(self, exchange)];
        self.viewControllerClass = EXClass(EXMultipleOrderViewController);
        
        __block EXProduct *product = nil;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            product = [accessor productBySymbol:@"eos_btc"];
        }];
        _product = product;
        
        NSDictionary *parameters1 = [params dictionaryByAddingDictionary:@{@"product": product}];
        EXOrderViewModel *unfinishedViewModel = [[EXOrderViewModel alloc] initWithServices:services params:parameters1];
        unfinishedViewModel.title = @"进行";
        
        NSDictionary *parameters2 = [params dictionaryByAddingDictionary:@{@"product": product, @"finished": @YES}];
        EXOrderViewModel *finishedViewModel = [[EXOrderViewModel alloc] initWithServices:services params:parameters2];
        finishedViewModel.title = @"完成";
        
        self.viewModels = @[unfinishedViewModel, finishedViewModel];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.selectProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self _transitProductViewModel];
        
        return [RACSignal empty];
    }];
    
    RAC(self, rightBarButtonItemTitle) = [RACObserve(self, product) map:^id(EXProduct *product) {
        return fmts(@"%@/%@", product.from.uppercaseString, product.to.uppercaseString);
    }];
    
    [[RACSignal combineLatest:@[[[RACObserve(self, product) distinctUntilChanged] ignore:nil], [RACObserve(self, viewModels) ignore:nil]]] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(EXProduct *product, NSArray<EXOrderViewModel *> *viewModels) = tuple;
        [viewModels setValue:product forKey:@"product"];
    }];
}

- (void)_transitProductViewModel{
    EXProductViewModel *viewModel = [[EXProductViewModel alloc] initWithServices:self.services params:@{@"exchange": self.exchange}];
    
    @weakify(self);
    viewModel.callback = ^(EXProduct *product) {
        @strongify(self);
        self.product = product;
        [self.services popViewModelAnimated:YES];
    };
    [[self services] pushViewModel:viewModel animated:YES];
}

@end
