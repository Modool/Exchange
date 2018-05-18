//
//  EXCommissionViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCommissionViewModel.h"
#import "RACSegmentViewController.h"

#import "EXDepthSetViewModel.h"
#import "EXDepthSetViewModel.h"
#import "EXDepthChartViewModel.h"

#import "EXProductManager.h"
#import "EXSocketManager.h"

@interface EXCommissionViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) EXDepthSet *depthSet;
@property (nonatomic, strong) RACTwoTuple<NSArray<EXDepth *> *, NSArray<EXDepth *> *> *tuple;

@property (nonatomic, strong) EXDepthSetViewModel *setViewModel;
@property (nonatomic, strong) EXDepthChartViewModel *chartViewModel;

@property (nonatomic, strong) RACScheduler *scheduler;

@end

@implementation EXCommissionViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _product = params[@keypath(self, product)];
        _exchange = params[@keypath(self, exchange)];
        
        self.setViewModel = [[EXDepthSetViewModel alloc] initWithServices:services params:params];
        self.chartViewModel = [[EXDepthChartViewModel alloc] initWithServices:services params:params];
        
        self.viewModels = @[self.setViewModel, self.chartViewModel];
        self.viewControllerClass = EXClass(RACSegmentViewController);
        
        NSString *queueName = @"com.markejave.modool.depth.set.queue";
        dispatch_queue_t queue = dispatch_queue_create(queueName.UTF8String, NULL);
        self.scheduler = [[RACQueueScheduler alloc] initWithName:queueName queue:queue];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self.setViewModel, tuple) = [RACObserve(self, tuple) ignore:nil];
    RAC(self.chartViewModel, tuple) = [RACObserve(self, tuple) ignore:nil];
    
    @weakify(self);
    RAC(self, tuple) = [[[[RACObserve(self, depthSet) map:^id(EXDepthSet *depthSet) {
        @strongify(self);
        NSArray<EXDepth *> *asks = depthSet.asks;
        NSArray<EXDepth *> *bids = depthSet.bids;
        return RACTuplePack(asks, bids, self.tuple.first, self.tuple.second);
    }] deliverOn:self.scheduler] reduceEach:^id(NSArray<EXDepth *> *asks, NSArray<EXDepth *> *bids, NSArray<EXDepth *> *localAsks, NSArray<EXDepth *> *localBids){
        @strongify(self);
        if (localAsks) localAsks = [self depths:localAsks byAddingDepths:asks];
        else localAsks = asks;
        
        if (localBids) localBids = [self depths:localBids byAddingDepths:bids];
        else localBids = bids;
        
        return RACTuplePack(localAsks, localBids);
    }] deliverOnMainThread];
    
    [self.didAppearSignal subscribeToTarget:self performSelector:@selector(_registerChannel)];
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    
    [self _registerDelegate];
}

- (NSArray<EXDepth *> *)depths:(NSArray<EXDepth *> *)depths byAddingDepths:(NSArray<EXDepth *> *)addingDepths{
    NSMutableArray<EXDepth *> *mutableDepths = [depths ?: @[] mutableCopy];
    
    for (EXDepth *depth in addingDepths) {
        if (depth.volume <= 0) {
            [mutableDepths.copy enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(EXDepth *dep, NSUInteger idx, BOOL *stop) {
                if (depth.price != dep.price) return;
                
                [mutableDepths removeObject:dep];
                *stop = YES;
            }];
        } else {
            __block NSUInteger index = NSNotFound;
            [mutableDepths.copy enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(EXDepth *dep, NSUInteger idx, BOOL *stop) {
                if (depth.price != dep.price) return;
                
                depth.volume += dep.volume;
                index = idx;
                *stop = YES;
            }];
            if (index == NSNotFound) [mutableDepths addObject:depth];
        }
    }
    [mutableDepths sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(EXDepth *depth1, EXDepth *depth2) {
        return (depth1.buy && depth1.price < depth2.price) || (!depth1.buy && depth1.price > depth2.price);
    }];
    return mutableDepths.copy;
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
        [accessor addDepthChannelWithSymbol:self.product.symbol];
    }];
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateDepthSet:(EXDepthSet *)depthSet;{
    self.depthSet = depthSet;
}

@end
