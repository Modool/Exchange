//
//  EXDepthSetViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepthSetViewModel.h"
#import "RACDefaultTableViewController.h"

#import "EXDepthItemViewModel.h"
#import "EXDepthCell.h"
#import "RACTableSection.h"

@interface EXDepthSetViewModel ()

@end

@implementation EXDepthSetViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super init]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        
        self.title = @"委托量";
        self.rowHeight = 30;
        self.viewControllerClass = EXClass(RACDefaultTableViewController);
        self.itemClasses = @{EXClassName(EXDepthItemViewModel): EXClass(EXDepthCell)};
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    RAC(self, dataSource) = [[RACObserve(self, tuple) ignore:nil] reduceEach:^id(NSArray<EXDepth *> *asks, NSArray<EXDepth *> *bids){
        @strongify(self);
        NSArray<EXDepthItemViewModel *> *viewModels = [self viewModelsWithAsks:asks bids:bids];
        return @[[RACTableSection sectionWithViewModels:viewModels]];
    }];
}

- (NSArray<EXDepthItemViewModel *> *)viewModelsWithAsks:(NSArray<EXDepth *> *)asks bids:(NSArray<EXDepth *> *)bids{
    NSMutableArray<EXDepthItemViewModel *> *viewModels = [NSMutableArray array];
    NSUInteger count = MAX(asks.count, bids.count);
    
    for (NSUInteger index = 0; index < count; index++) {
        EXDepth *ask = index < asks.count ? asks[index] : nil;
        EXDepth *bid = index < bids.count ? bids[index] : nil;
        [viewModels addObject:[self viewModelWithAsk:ask bid:bid]];
    }
    return viewModels.copy;
}

- (EXDepthItemViewModel *)viewModelWithAsk:(EXDepth *)ask bid:(EXDepth *)bid{
    return [[EXDepthItemViewModel alloc] initWithAsk:ask bid:bid];
}

@end
