//
//  EXTransactionViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTransactionViewModel.h"
#import "EXTransactionViewController.h"
#import "EXProductDetailViewModel.h"

#import "EXProductCell.h"

#import "EXProductManager.h"
#import "EXExchangeManager.h"

#import "RACTableSection.h"

@interface EXTransactionViewModel ()

@property (nonatomic, strong) RACCommand *collectCommand;

@property (nonatomic, strong) EXExchange *exchange;

@end

@implementation EXTransactionViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.perPage = 10;
        self.rowHeight = 70;
        self.shouldPullToLoadMore = YES;
        self.viewControllerClass = EXClass(EXTransactionViewController);
        self.itemClasses = @{EXClassName(EXProductItemViewModel): EXClass(EXProductCell)};
        __block EXExchange *exchange = nil;
        [EXExchangeManager sync:^(EXDelegatesAccessor<EXExchangeManager> *accessor) {
            exchange = [accessor exchangeByDomain:EXExchangeOKExDomain];
        }];
        self.exchange = exchange;
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
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        EXProductItemViewModel *item = [self viewModelAtIndexPath:indexPath];
        EXProductDetailViewModel *viewModel = [[EXProductDetailViewModel alloc] initWithServices:self.services params:@{@keypath(item, exchange): item.exchange, @keypath(item, product): item.product}];
        
        @weakify(item);
        viewModel.collection = ^(EXProduct *product, BOOL collected) {
            @strongify(item);
            item.collected = collected;
        };
        
        [[self services] pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.collectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(EXProductItemViewModel *viewModel) {
        @strongify(self);
        return [[self collectSignalWithViewModel:viewModel collected:!viewModel.collected] takeUntil:[self rac_willDeallocSignal]];
    }];
    
    [self.collectCommand.errors subscribe:self.errors];
}

#pragma mark - protected

- (BOOL)allowEditAtIndexPath:(NSIndexPath *)indexPath;{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath;{
    EXProductItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    NSString *title = viewModel.collected ? @"取消收藏" : @"收藏";
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title viewModel:viewModel command:self.collectCommand];
    action.backgroundColor = viewModel.collected ? [UIColor grayColor] : [UIColor redColor];
    
    return @[action];
}

- (NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    EXProductItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    NSString *title = viewModel.collected ? @"取消收藏" : @"收藏";
    UIContextualAction *action = [UIContextualAction actionWithStyle:UIContextualActionStyleNormal title:title viewModel:viewModel command:self.collectCommand];
    action.backgroundColor = viewModel.collected ? [UIColor grayColor] : [UIColor redColor];
    
    return @[action];
}

#pragma mark - public

- (EXProductItemViewModel *)viewModelOfProduct:(EXProduct *)product;{
    id<RACTableSection> section = self.dataSource.firstObject;
    
    return (id)[section.viewModels.rac_sequence objectPassingTest:^BOOL(EXProductItemViewModel *viewModel) {
        return [viewModel.product isEqual:product];
    }];
}

- (EXProductItemViewModel *)viewModelWithProduct:(EXProduct *)product{
    return [[EXProductItemViewModel alloc] initWithProduct:product exchange:self.exchange];
}

- (NSArray<EXProductItemViewModel *> *)viewModelsWithProducts:(NSArray<EXProduct *> *)products;{
    @weakify(self);
    return [[products.rac_sequence map:^id(EXProduct *product) {
        @strongify(self);
        return [self viewModelWithProduct:product];
    }] array];
}

#pragma mark - signal accessor

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXProduct *> *products = [accessor productsAtPage:page size:self.perPage];
            
            [[[RACSignal return:products] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

- (RACSignal *)collectSignalWithViewModel:(EXProductItemViewModel *)viewModel collected:(BOOL)collected{
    NSString *symbol = viewModel.product.symbol;
    
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            BOOL state = collected ? [accessor collectProductWithSymbol:symbol] : [accessor descollectProductWithSymbol:symbol];
            RACSignal *signal = nil;
            if (state) signal = [RACSignal return:viewModel];
            else signal = [RACSignal error:[NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"操作失败"}]];
            
            [[[signal subscribeOn:[RACScheduler mainThreadScheduler]] doNext:^(id x) {
                viewModel.collected = collected;
            }] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

@end
