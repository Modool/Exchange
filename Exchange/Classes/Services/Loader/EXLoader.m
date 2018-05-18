//
//  EXLoader.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXLoader.h"

#import "EXCompatQueue.h"
#import "EXDevice.h"

#import "NSArray+EXAdditions.h"

@interface EXLoader ()

@property (nonatomic, strong) EXDevice *device;

@property (nonatomic, assign, getter=isCompatFinished) BOOL compatFinish;

@end

@implementation EXLoader
@dynamic delegates;

#pragma mark - public

- (void)installItems;{
    [super sync:^{
        [self _installItems];
    }];
}

- (void)uninstallItems;{
    [super sync:^{
        [self _uninstallItems];
    }];
}

- (void)reloadItems;{
    [super sync:^{
        [self _reloadItems];
    }];
}

- (void)compatItems {
    [super sync:^{
        [self _compatItems];
    }];
}

- (void)loadWithDevice:(EXDevice *)device{
    self.device = device;
    
    [self installItems];
    [self compatItems];
    [self reloadItems];
}

#pragma mark - private

- (void)_installItems;{
    for (MDQueueObject<EXLoaderItem> *item in self.device.modulers) {
        if (![item respondsToSelector:@selector(install)]) continue;
        
        [self _respondWillInstallItem:item];
        [item sync:^{
            [item install];
        }];
        [self _respondDidInstallItem:item];
    }
}

- (void)_uninstallItems;{
    for (MDQueueObject<EXLoaderItem> *item in self.device.modulers) {
        if (![item respondsToSelector:@selector(uninstall)]) continue;
        
        [self _respondWillUninstallItem:item];
        [item sync:^{
            [item uninstall];
        }];
        
        [self _respondDidUninstallItem:item];
    }
}

- (void)_reloadItems;{
    for (MDQueueObject<EXLoaderItem> *item in self.device.modulers) {
        if (![item respondsToSelector:@selector(reload)]) continue;
        
        [self _respondWillReloadItem:item];
        [item sync:^{
            [item reload];
        }];
        [self _respondDidReloadItem:item];
    }
}

- (void)_compatItems{
    EXLogger(@"Compat accessor items");
    [self _respondWillBeginCompats];
    
    for (id<EXLoaderCompatItem> item in self.device.modulers) {
        if (![item conformsToProtocol:@protocol(EXLoaderCompatItem)] ||
            ![item respondsToSelector:@selector(compatQueue)]) continue;
        
        [self _respondWillCompatWithItem:item];
        
        EXCompatQueue *itemQueue = [item compatQueue];
        [itemQueue schedule];
        long state = [itemQueue waitUntilFinished];
        if (state) EXLogger(@"Failed to compat item: %@.", item);
        
        [self _respondDidCompatWithItem:item];
    }
    
    [self _respondDidEndCompats];
}

- (void)_respondWillBeginCompats{
    self.compatFinish = NO;
    
    if ([[self delegates] respondsToSelector:@selector(loaderWillBeginCompats:)]) {
        [[self delegates] loaderWillBeginCompats:self];
    }
}

- (void)_respondDidEndCompats{
    self.compatFinish = YES;
    
    if ([[self delegates] respondsToSelector:@selector(loaderDidEndCompats:)]) {
        [[self delegates] loaderDidEndCompats:self];
    }
}

- (void)_respondWillCompatWithItem:(id<EXLoaderCompatItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:willCompatWithItem:)]) {
        [[self delegates] loader:self willCompatWithItem:item];
    }
}

- (void)_respondDidCompatWithItem:(id<EXLoaderCompatItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:didCompatWithItem:)]) {
        [[self delegates] loader:self didCompatWithItem:item];
    }
}

- (void)_respondWillInstallItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:willInstallItem:)]) {
        [[self delegates] loader:self willInstallItem:item];
    }
}

- (void)_respondDidInstallItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:didInstallItem:)]) {
        [[self delegates] loader:self didInstallItem:item];
    }
}

- (void)_respondWillUninstallItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:willUninstallItem:)]) {
        [[self delegates] loader:self willUninstallItem:item];
    }
}

- (void)_respondDidUninstallItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:didUninstallItem:)]) {
        [[self delegates] loader:self didUninstallItem:item];
    }
}

- (void)_respondWillReloadItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:willReloadItem:)]) {
        [[self delegates] loader:self willReloadItem:item];
    }
}

- (void)_respondDidReloadItem:(id<EXLoaderItem>)item{
    if ([[self delegates] respondsToSelector:@selector(loader:didReloadItem:)]) {
        [[self delegates] loader:self didReloadItem:item];
    }
}

@end
