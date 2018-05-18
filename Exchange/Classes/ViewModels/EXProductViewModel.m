//
//  EXProductViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductViewModel.h"
#import "EXProductViewController.h"

#import "EXProductBriefCell.h"

#import "EXProductManager.h"

@implementation EXProductViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _exchange = params[@keypath(self, exchange)];
        
        self.title = @"交易对";
        self.perPage = 20;
        self.rowHeight = 50;
        self.shouldPullToLoadMore = YES;
        self.viewControllerClass = EXClass(EXProductViewController);
        self.itemClasses = @{EXClassName(EXProductBriefItemViewModel): EXClass(EXProductBriefCell)};
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        EXProductBriefItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
        if (self.callback) self.callback(viewModel.product);
        
        return [RACSignal empty];
    }];
}

#pragma mark - transformer

- (NSArray<EXProductBriefItemViewModel *> *)viewModelsWithProducts:(NSArray<EXProduct *> *)products{
    @weakify(self);
    return [[[products rac_sequence] map:^id(EXProduct *product) {
        @strongify(self);
        return [self viewModelWithProduct:product];
    }] array];
}

- (EXProductBriefItemViewModel *)viewModelWithProduct:(EXProduct *)product{
    return [EXProductBriefItemViewModel viewModelWithProduct:product];
}

#pragma mark - signal accessor

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    NSUInteger size = self.perPage;
    
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXProduct *> *products = [accessor productsByExchange:nil keywords:nil collected:-1 page:page size:size];
            [[[RACSignal return:products] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

@end
