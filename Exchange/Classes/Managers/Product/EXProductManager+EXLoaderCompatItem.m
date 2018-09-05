//
//  EXProductManager+EXLoaderCompatItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager+EXLoaderCompatItem.h"
#import "EXProductManager+Database.h"
#import "EXProduct+Private.h"

#import "EXCompatQueue.h"
#import "EXCompatOperation.h"


const CGFloat EXProductManagerVersion = 1.0;

@implementation EXProductManager (EXLoaderCompatItem)

- (EXCompatQueue *)compatQueue;{
    NSString *key = [NSStringFromClass([self class]) stringByAppendingString:EXCompatOperationVersionKeySuffix];
    EXCompatQueue *queue = [EXCompatQueue queueWithKey:key currentVersion:EXProductManagerVersion];

    [queue addOperation:self.firstCompatOperation];

    return queue;
}

- (EXCompatOperation *)firstCompatOperation{
    @weakify(self);
    EXCompatOperation *operation = [EXCompatOperation operationWithVersion:0.0];
    operation.compatBlock = ^(EXCompatOperation *operation, CGFloat version, CGFloat localVersion) {
        @strongify(self);
        NSArray<NSDictionary *> *ditionaries = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"okex_products" withExtension:@"plist"]];
        
        [self _insertProductsWithBlock:^EXProduct *(NSUInteger index, BOOL *stop) {
            *stop = index == (ditionaries.count - 1);
            EXProduct *product = [EXProduct modelWithDictionary:ditionaries[index]];
            product.exchangeDomain = EXExchangeOKExDomain;
            product.collected = [@[@"eth_usdt", @"eos_usdt", @"btc_usdt", @"ltc_usdt", @"bch_usdt"] containsObject:product.symbol];
            return product;
        } block:nil];
    };
    return operation;
}

@end
