//
//  EXProductManager+Compat.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+Compat.h"
#import "EXProductManager+Database.h"
#import "EXProduct.h"

const CGFloat EXProductManagerVersion = 1.0;

@implementation EXProductManager (Compat)

+ (NSArray<EXCompatOperation *> *)compatOperations;{
    return @[self.firstCompatOperation];
}

+ (EXCompatOperation *)firstCompatOperation{
    return [EXCompatOperation operationWithVersion:0.0 block:^(EXCompatOperation *operation, CGFloat version, CGFloat localVersion) {
        [self sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            NSArray<NSDictionary *> *products = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"okex_products" withExtension:@"plist"]];
            EXProductManager *manager = (id)accessor;
            
            [manager _insertProductsWithBlock:^EXProduct *(NSUInteger index, BOOL *stop) {
                *stop = index == (products.count - 1);
                return [EXProduct modelWithDictionary:products[index]];
            } block:nil];
        }];
    }];
}

@end
