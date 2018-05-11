//
//  RACTableViewModel.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACTableViewModel.h"
#import "RACTableSection.h"

#import "EXMacros.h"

@implementation UITableViewRowAction (RACCommand)

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title command:(RACCommand *)command;{
    return [self rowActionWithStyle:style title:title viewModel:nil command:command];
}

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title viewModel:(id)viewModel command:(RACCommand *)command;{
    return [self rowActionWithStyle:style title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [command execute:viewModel ?: indexPath];
    }];
}

+ (UITableViewRowAction *)deleteActionCommand:(RACCommand *)command;{
    return [self rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" command:command];
}

@end

@implementation UIContextualAction(RACCommand)

+ (instancetype)actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title viewModel:(id)viewModel command:(RACCommand *)command;{
    return [self contextualActionWithStyle:style title:title handler:^(UIContextualAction * action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [[command execute:viewModel] subscribeNext:^(id x) {
            completionHandler(YES);
        } error:^(NSError *error) {
            completionHandler(NO);
        }];
    }];
}

+ (instancetype)actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title indexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;{
    return [self contextualActionWithStyle:style title:title handler:^(UIContextualAction * action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [[command execute:indexPath] subscribeNext:^(id x) {
            completionHandler(YES);
        } error:^(NSError *error) {
            completionHandler(NO);
        }];
    }];
}

+ (UIContextualAction *)deleteActionAtIndexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;{
    return [self actionWithStyle:UIContextualActionStyleDestructive title:@"删除" indexPath:indexPath command:command];
}

@end

@implementation NSIndexPath (EXAdditions)

+ (NSIndexSet *)indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;{
    return [self indexSetWithIndexPaths:indexPaths inSection:0];
}

+ (NSIndexSet *)indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths inSection:(NSUInteger)section;{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in indexPaths) {
        if ([indexPath section] != section) continue;
        
        [indexSet addIndex:[indexPath row]];
    }
    return indexSet;
}

@end

@interface RACTableViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *requestDataCommand;

@end

@implementation RACTableViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    self = [super initWithServices:services params:params];
    if (self) {
        self.page = 1;
        self.perPage = 10;
        self.loadMoreEnabled = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.requestDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self);
        return [[self requestDataSignalWithPage:[page unsignedIntegerValue]] takeUntil:[self rac_willDeallocSignal]];
    }];
    
    self.deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if (!input) return [RACSignal empty];
        
        id viewModel = nil;
        NSNumber *animation = @(UITableViewRowAnimationNone);
        if ([input isKindOfClass:[RACTuple class]]) {
            viewModel = [(RACTuple *)input first];
            animation = [(RACTuple *)input second];
        } else {
            viewModel = input;
        }
        
        @strongify(self);
        return [[[self deleteSignalWithViewModel:viewModel] combineLatestWith:[RACSignal return:animation]] takeUntil:[self rac_willDeallocSignal]];
    }];
    self.deleteCommand.allowsConcurrentExecution = YES;
    
    self.insertCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id viewModel) {
        if (!viewModel) return [RACSignal empty];
        
        @strongify(self);
        return [[self insertSignalWithViewModel:viewModel] takeUntil:[self rac_willDeallocSignal]];
    }];
    self.insertCommand.allowsConcurrentExecution = YES;
    
    [[[[self requestDataCommand] errors] filter:[self requestDataErrorsFilter]] subscribe:[self errors]];
}

- (void)refresh;{}
- (void)loadMore;{}

- (BOOL (^)(NSError *error))requestDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (BOOL)allowEditAtIndexPath:(NSIndexPath *)indexPath;{
    return NO;
}

- (BOOL)allowSelectAtIndexPath:(NSIndexPath *)indexPath;{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath;{
    return @[];
}

- (NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @[];
}

- (NSArray<UIContextualAction *> *)leadingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return @[];
}

- (UISwipeActionsConfiguration *)trailingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0)) {
    UISwipeActionsConfiguration *configration = [UISwipeActionsConfiguration configurationWithActions:actions];
    configration.performsFirstActionWithFullSwipe = NO;
    
    return configration;
}

- (UISwipeActionsConfiguration *)leadingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0)) {
    UISwipeActionsConfiguration *configration = [UISwipeActionsConfiguration configurationWithActions:actions];
    configration.performsFirstActionWithFullSwipe = NO;
    
    return configration;
}

- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return [self rowHeight];
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * [self perPage];
}

- (id)viewModelAtIndexPath:(NSIndexPath *)indexPath;{
    id<RACTableSection> tableSection = self.dataSource[[indexPath section]];
    
    return tableSection.viewModels[[indexPath row]];
}

- (NSIndexPath *)indexPathWithViewModel:(id)viewModel;{
    NSArray<RACTableSection *> *dataSource = [[self dataSource] copy];
    NSUInteger numberOfSections = [[self dataSource] count];
    
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        id<RACTableSection> tableSection = dataSource[section];
        NSUInteger numberOfRows = [[tableSection viewModels] count];
        
        for (NSUInteger row = 0; row < numberOfRows; row++) {
            RACViewModel *local = tableSection.viewModels[row];
            if (viewModel == local || [viewModel isEqual:local]) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    
    return nil;
}

- (Class<RACView, NSObject>)classForViewModel:(id)viewModel;{
    return self.itemClasses[EXClassName(viewModel)];
}

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

- (RACSignal *)deleteSignalWithViewModel:(id)viewModel {
    return [RACSignal return:viewModel];
}

- (RACSignal *)insertSignalWithViewModel:(id)viewModel {
    return [RACSignal return:viewModel];
}

@end
