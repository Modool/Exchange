//
//  EXAccountRecord.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXAccountRecord.h"

@interface EXAccountRecord ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *bank;

@property (nonatomic, copy) NSString *benificiaryAddress;

@property (nonatomic, assign) double transactionValue;

@property (nonatomic, assign) double fee;

@property (nonatomic, assign) double amount;

@property (nonatomic, assign) NSTimeInterval date;

@end

@implementation EXAccountRecord


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXAccountRecord *record;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(record, exchangeDomain): @"exchange_domain",
               @keypath(record, symbol): @"symbol",
               @keypath(record, address): @"addr",
               @keypath(record, account): @"account",
               @keypath(record, bank): @"bank",
               @keypath(record, benificiaryAddress): @"benificiary_addr",
               @keypath(record, transactionValue): @"transaction_value",
               @keypath(record, fee): @"fee",
               @keypath(record, amount): @"amount",
               @keypath(record, time): @"date",
               @keypath(record, status): @"status",
               }];
}

- (NSString *)productID{
    return EXProductID(self.exchangeDomain, self.symbol);
}

@end
