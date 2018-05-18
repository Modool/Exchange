//
//  EXLoader.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"
#import "EXLoaderItem.h"

@class EXLoader, EXDevice;
@protocol EXLoaderDelegate <NSObject>

@optional

- (void)loader:(EXLoader *)loader willUninstallItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didUninstallItem:(id<EXLoaderItem>)item;

- (void)loader:(EXLoader *)loader willInstallItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didInstallItem:(id<EXLoaderItem>)item;

- (void)loader:(EXLoader *)loader willReloadItem:(id<EXLoaderItem>)item;
- (void)loader:(EXLoader *)loader didReloadItem:(id<EXLoaderItem>)item;

@end

@protocol EXLoaderCompatDelegate <NSObject>

@optional
- (void)loader:(EXLoader *)loader willCompatWithItem:(id<EXLoaderCompatItem>)item;
- (void)loader:(EXLoader *)loader didCompatWithItem:(id<EXLoaderCompatItem>)item;

- (void)loaderWillBeginCompats:(EXLoader *)loader;
- (void)loaderDidEndCompats:(EXLoader *)loader;

@end

@interface EXLoader : EXDelegatesAccessor

@property (nonatomic, assign, readonly, getter=isCompatFinished) BOOL compatFinish;

@property (nonatomic, strong, readonly) MDMulticastDelegate<EXLoaderDelegate, EXLoaderCompatDelegate> *delegates;

- (void)async:(dispatch_block_t)block EX_UNAVAILABLE;
- (void)sync:(dispatch_block_t)block EX_UNAVAILABLE;

- (void)installItems;
- (void)uninstallItems;
- (void)reloadItems;

- (void)loadWithDevice:(EXDevice *)device;

@end
