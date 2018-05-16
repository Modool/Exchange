//
//  EXBalance.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalance.h"
#import "EXBalance+Private.h"

@implementation EXBalance

+ (NSDictionary *)modelCustomPropertyMapper{
    EXBalance *balance;
    return [[self modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(balance, objectID): @"id",
               @keypath(balance, exchangeDomain): @"exchange_domain",
               }];
}

- (double)all{
    return _free + _freezed + _borrow;
}

- (BOOL)isZero{
    return self.all == 0;
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end
