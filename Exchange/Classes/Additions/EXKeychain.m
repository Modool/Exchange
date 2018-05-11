//
//  EXKeychain.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "EXKeychain.h"

NSString * const EXKeychainServiceDomain = @"com.Exchange.exchange.keychain.service.domain";

@implementation EXKeychain

+ (NSString *)passwordForKey:(NSString *)key;{
    return [SSKeychain passwordForService:EXKeychainServiceDomain account:key];
}

+ (void)setPassword:(NSString *)password forKey:(NSString *)key;{
    [SSKeychain setPassword:password forService:EXKeychainServiceDomain account:key];
}

@end
