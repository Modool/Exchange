
//
//  EXProductManager+EXLoaderItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+EXLoaderItem.h"
#import "EXProductManager+Private.h"
#import "EXProductManager+EXSelectedProduct.h"
#import "EXProductManager+EXSocketManagerDelegate.h"

@implementation EXProductManager (EXLoaderItem)

- (void)reload;{
    NSArray<NSDictionary *> *array = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"okex_products" withExtension:@"plist"]];
    NSError *error = nil;
    NSArray<EXProduct *> *products = [array modelsOfClass:[EXProduct class] error:&error];
        
    self.mutableOrders = [NSMutableDictionary dictionary];
    self.orders = [NSMutableDictionary dictionary];
    self.trades = [NSMutableDictionary dictionary];
    self.lines = [NSMutableDictionary dictionary];
    self.tickers = [NSMutableDictionary dictionary];
    self.depths = [NSMutableDictionary dictionary];
    self.products = [NSMutableDictionary dictionaryWithObjects:products forKeys:[products valueForKey:@keypath(EXProduct.new, symbol)]];
    
    self.symbolDelegates = [NSMutableDictionary dictionary];
    
    [self _readCollectedProduct];
}

- (void)install;{
    [self registerDelegateForAcceessor:[EXSocketManager class]];
}

@end
