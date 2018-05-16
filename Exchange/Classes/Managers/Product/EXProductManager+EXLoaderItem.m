
//
//  EXProductManager+EXLoaderItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+EXLoaderItem.h"
#import "EXProductManager+Private.h"
#import "EXProductManager+EXSocketManagerDelegate.h"

@implementation EXProductManager (EXLoaderItem)

- (void)reload;{
    self.symbolDelegates = [NSMutableDictionary dictionary];
}

- (void)install;{
    [self registerDelegateForAcceessor:[EXSocketManager class]];
}

@end
