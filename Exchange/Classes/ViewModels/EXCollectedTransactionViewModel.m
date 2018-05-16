//
//  EXCollectedTransactionViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCollectedTransactionViewModel.h"

#import "EXProductManager.h"

@interface EXCollectedTransactionViewModel () <EXProductManagerDelegate>

@end

@implementation EXCollectedTransactionViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"自选";
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(productManager:didUpdateProduct:collected:)] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(id x, EXProduct *product, NSNumber *collected) = tuple;
        @strongify(self);
        if (collected.boolValue) {
            EXProductItemViewModel *viewModel = [self viewModelWithProduct:product];
            [self.insertCommand execute:viewModel];
        } else {
            EXProductItemViewModel *viewModel = [self viewModelOfProduct:product];
            [self.deleteCommand execute:RACTuplePack(viewModel, @(UITableViewRowAnimationFade))];
        }
    }];
    
    [self _registerDelegate];
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
}

#pragma mark - private

- (void)_registerDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }];
}

- (void)_deregisterDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    }];
}

#pragma mark - signal accessor

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXProduct *> *products = [accessor collectedProductsAtPage:page size:self.perPage];
            [[[RACSignal return:products] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

@end
