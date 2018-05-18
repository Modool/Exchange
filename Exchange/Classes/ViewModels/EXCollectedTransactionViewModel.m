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
    [[self rac_signalForSelector:@selector(productManager:didUpdateProduct:collected:) fromProtocol:@protocol(EXProductManagerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if ([tuple.third boolValue]) {
            EXProductItemViewModel *viewModel = [self viewModelWithProduct:tuple.second];
            [self.insertCommand execute:viewModel];
        } else {
            EXProductItemViewModel *viewModel = [self viewModelOfProduct:tuple.second];
            [self.deleteCommand execute:RACTuplePack(viewModel, @(UITableViewRowAnimationFade))];
        }
    }];
    
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    [self _registerDelegate];
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
    NSUInteger size = self.perPage;
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXProduct *> *products = [accessor productsByExchange:nil keywords:nil collected:YES page:page size:size];
            [[[RACSignal return:products] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

@end
