//
//  EXLoader.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXLoader.h"

#import "NSArray+EXAdditions.h"

@interface EXLoader ()

@property (nonatomic, copy) NSArray<EXLoaderItem> *items;

@end

@implementation EXLoader
@dynamic delegates;

#pragma mark - accessor

- (NSArray<EXLoaderItem> *)items{
    if (!_items) {
        _items = [NSArray<EXLoaderItem> array];
    }
    return _items;
}

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

- (BOOL)addItem:(id<EXLoaderItem>)item;{
    __block BOOL state = NO;
    [super sync:^{
        state = [self _addItem:item];
    }];
    return state;
}

- (BOOL)removeItem:(id<EXLoaderItem>)item;{
    __block BOOL state = NO;
    [super sync:^{
        state = [self _removeItem:item];
    }];
    return state;
}

#pragma mark - private

- (void)_installItems;{
    for (MDQueueObject<EXLoaderItem> *item in [self items]) {
        if (![item respondsToSelector:@selector(install)]) continue;
        
        [self _respondWillInstallItem:item];
        [item sync:^{
            [item install];
        }];
        [self _respondDidInstallItem:item];
    }
}

- (void)_uninstallItems;{
    for (MDQueueObject<EXLoaderItem> *item in [self items]) {
        if (![item respondsToSelector:@selector(uninstall)]) continue;
        
        [self _respondWillUninstallItem:item];
        [item sync:^{
            [item uninstall];
        }];
        
        [self _respondDidUninstallItem:item];
    }
}

- (void)_reloadItems;{
    for (MDQueueObject<EXLoaderItem> *item in [self items]) {
        if (![item respondsToSelector:@selector(reload)]) continue;
        
        [self _respondWillReloadItem:item];
        [item sync:^{
            [item reload];
        }];
        [self _respondDidReloadItem:item];
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

- (BOOL)_addItem:(id<EXLoaderItem>)item;{
    NSParameterAssertReturnFalse(item);
    NSParameterAssertReturnFalse(![[self items] containsObject:item]);
    
    [self addDelegate:item delegateQueue:[item queue]];
    
    self.items = (id)[[self items] arrayByAddingObject:item];
    
    return YES;
}

- (BOOL)_removeItem:(id<EXLoaderItem>)item;{
    NSParameterAssertReturnFalse(item);
    NSParameterAssertReturnFalse([[self items] containsObject:item]);
    
    [self removeDelegate:item delegateQueue:[item queue]];
    
    self.items = (id)[[self items] arrayByRemovingObject:item];
    
    return YES;
}

@end
