//
//  NSError+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (EXAdditions)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo underlyingError:(NSError *)underlyingError;

@end
