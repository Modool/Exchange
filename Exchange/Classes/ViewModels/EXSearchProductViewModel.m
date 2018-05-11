//
//  EXSearchProductViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/28.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSearchProductViewModel.h"
#import "EXSearchProductViewController.h"
#import "EXProductBriefItemViewModel.h"

#import "EXProductManager.h"

@interface EXSearchProductViewModel ()

@property (nonatomic, strong) RACCommand *collectCommand;

@end

@implementation EXSearchProductViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.shouldPullToRefresh = NO;
        self.shouldRequestRemoteDataOnViewDidLoad = NO;
        self.viewControllerClass = EXClass(EXSearchProductViewController);
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.collectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(EXProductBriefItemViewModel *viewModel) {
        @strongify(self);
        return [[self collectSignalWithViewModel:viewModel collect:!viewModel.collected] takeUntil:[self rac_willDeallocSignal]];
    }];
    
    [self.collectCommand.errors subscribe:self.errors];
}

#pragma mark - protected

- (BOOL)allowEditAtIndexPath:(NSIndexPath *)indexPath;{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath;{
    EXProductBriefItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    NSString *title = viewModel.collected ? @"取消收藏" : @"收藏";
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title viewModel:viewModel command:self.collectCommand];
    action.backgroundColor = viewModel.collected ? [UIColor grayColor] : [UIColor redColor];
    
    return @[action];
}

- (NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    EXProductBriefItemViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    NSString *title = viewModel.collected ? @"取消收藏" : @"收藏";
    UIContextualAction *action = [UIContextualAction actionWithStyle:UIContextualActionStyleNormal title:title viewModel:viewModel command:self.collectCommand];
    action.backgroundColor = viewModel.collected ? [UIColor grayColor] : [UIColor redColor];
    
    return @[action];
}

#pragma mark - signal accessor

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page{
    NSString *keyword = self.keyword;
    if (!keyword.length) return [RACSignal return:nil];
    
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<EXProduct *> *products = [accessor productsWithKeyword:keyword page:page size:self.perPage];
            [[[RACSignal return:products] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

- (RACSignal *)collectSignalWithViewModel:(EXProductBriefItemViewModel *)viewModel collect:(BOOL)collect{
    NSString *symbol = viewModel.product.symbol;
    
    return [[[RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        [EXProductManager async:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            BOOL state = collect ? [accessor collectProductWithSymbol:symbol] : [accessor descollectProductWithSymbol:symbol];
            RACSignal *signal = nil;
            if (state) signal = [RACSignal return:viewModel];
            else signal = [RACSignal error:[NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"操作失败"}]];
            
            [[[signal subscribeOn:[RACScheduler mainThreadScheduler]] doNext:^(id x) {
                viewModel.collected = collect;
            }] subscribe:subscriber];
        }];
    }] replayLazily] setNameWithFormat:RACSignalDefaultNameFormat];
}

@end
