//
//  EXLoader.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"
#import "EXLoaderItem.h"

@class EXLoader;
@protocol EXLoaderDelegate <NSObject>

@optional

- (void)loader:(EXLoader *)loader willUninstallItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didUninstallItem:(id<EXLoaderItem>)item;

- (void)loader:(EXLoader *)loader willInstallItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didInstallItem:(id<EXLoaderItem>)item;

- (void)loader:(EXLoader *)loader willReloadItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didReloadItem:(id<EXLoaderItem>)item;

@end

@interface EXLoader : EXDelegatesAccessor

@property (nonatomic, copy, readonly) NSArray<EXLoaderItem> *items;

@property (nonatomic, strong, readonly) MDMulticastDelegate<EXLoaderDelegate> *delegates;

- (void)async:(dispatch_block_t)block EX_UNAVAILABLE;
- (void)sync:(dispatch_block_t)block EX_UNAVAILABLE;

- (void)installItems;
- (void)uninstallItems;
- (void)reloadItems;

- (BOOL)addItem:(MDQueueObject<EXLoaderItem> *)item;
- (BOOL)removeItem:(MDQueueObject<EXLoaderItem> *)item;

@end
