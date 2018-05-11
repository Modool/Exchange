//
//  EXWithdraw.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXWithdraw.h"

@interface EXWithdraw ()

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) double amount;

@property (nonatomic, assign) double fee;

@property (nonatomic, assign) EXWithdrawStatus status;

@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation EXWithdraw

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXWithdraw *withdraw;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(withdraw, objectID): @"withdraw_id",
               @keypath(withdraw, address): @"address",
               @keypath(withdraw, amount): @"amount",
               @keypath(withdraw, fee): @"chargefee",
               @keypath(withdraw, status): @"status",
               @keypath(withdraw, time): @"created_date",
               }];
}

@end
