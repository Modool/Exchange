//
//  RACTableViewModel.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACControllerViewModel.h"

@class RACCommand, RACSignal;
@interface UITableViewRowAction (RACCommand)

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title command:(RACCommand *)command;
+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title viewModel:(id)viewModel command:(RACCommand *)command;

+ (UITableViewRowAction *)deleteActionCommand:(RACCommand *)command;

@end

API_AVAILABLE(ios(11.0))
@interface UIContextualAction(RACCommand)

+ (instancetype)actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title viewModel:(id)viewModel command:(RACCommand *)command;
+ (instancetype)actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title indexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;

+ (UIContextualAction *)deleteActionAtIndexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;

@end

@interface NSIndexPath (EXAdditions)

+ (NSIndexSet *)indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
+ (NSIndexSet *)indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths inSection:(NSUInteger)section;

@end

@protocol RACTableSection;
@interface RACTableViewModel : RACControllerViewModel

@property (nonatomic, assign) UITableViewStyle style;

/// The data source of table view.
@property (nonatomic, copy) NSArray<RACTableSection> *dataSource;

@property (nonatomic, copy) NSDictionary<NSString *, Class<RACView, NSObject>> *footerHeaderItemClasses;
@property (nonatomic, copy) NSDictionary<NSString *, Class<RACView, NSObject>> *itemClasses;

/// The list of section titles to display in section index view.
@property (nonatomic, copy) NSArray *sectionIndexTitles;

@property (nonatomic, assign) CGFloat rowHeight; // default is 0.

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldPullToLoadMore;

@property (nonatomic, assign, getter=isLoadMoreEnabled) BOOL loadMoreEnabled;
- (void)refresh;
- (void)loadMore;

@property (nonatomic, copy) NSString *keyword;

// input: RACTuplePack(itemViewModel, animated) or itemViewModel output: RACTuplePack(itemViewModel, animated)
@property (nonatomic, strong) RACCommand *insertCommand;

// input: RACTuplePack(itemViewModel, animated) or itemViewModel output: RACTuplePack(itemViewModel, animated)
@property (nonatomic, strong) RACCommand *deleteCommand;

@property (nonatomic, strong) RACCommand *didSelectCommand;

@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;
@property (nonatomic, strong, readonly) RACCommand *requestDataCommand;

- (BOOL (^)(NSError *error))requestDataErrorsFilter;

- (BOOL)allowEditAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)allowSelectAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);

- (NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));
- (NSArray<UIContextualAction *> *)leadingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));

- (UISwipeActionsConfiguration *)trailingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0));
- (UISwipeActionsConfiguration *)leadingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0));

- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)offsetForPage:(NSUInteger)page;

- (id)viewModelAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathWithViewModel:(id)viewModel;
- (Class<RACView, NSObject>)classForViewModel:(id)viewModel;

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page;

- (RACSignal *)deleteSignalWithViewModel:(id)viewModel;
- (RACSignal *)insertSignalWithViewModel:(id)viewModel;

@end
