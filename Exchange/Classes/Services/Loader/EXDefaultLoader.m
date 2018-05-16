//
//  EXDefaultLoader.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDefaultLoader.h"

#import "EXDelegatesAccessor+Private.h"
#import "EXDelegatesAccessor+EXAccessors.h"

@implementation EXDefaultLoader

+ (instancetype)defaultLoader;{
    static EXDefaultLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [self new];
        
        for (EXDelegatesAccessor<EXLoaderItem> *accessor in [EXDelegatesAccessor sharedAccessors]) {
            [loader addItem:accessor];
        }
    });
    return loader;
}

- (void)load{
    [self installItems];
    [self reloadItems];
}

@end
