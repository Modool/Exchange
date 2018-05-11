//
//  NSError+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "NSError+EXAdditions.h"

@implementation NSError (EXAdditions)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo underlyingError:(NSError *)underlyingError;{
    NSMutableDictionary *mutableUserInfo = [userInfo ?: @{} mutableCopy];
    if (underlyingError) {
        mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    return [NSError errorWithDomain:domain code:code userInfo:mutableUserInfo];
}

@end
