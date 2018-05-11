//
//  NSData+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+EXAdditions.h"

@implementation NSData (EXJSONSerializing)

// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options;{
    return [NSJSONSerialization JSONObjectWithData:self options:options error:nil];
}

- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error;{
    return [NSJSONSerialization JSONObjectWithData:self options:options error:error];
}

- (id)mutableObjectFromJSONData;{
    return [[self objectFromJSONData] mutableCopy];
}

- (id)mutableObjectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options;{
    return [[self objectFromJSONDataWithParseOptions:options] mutableCopy];
}

- (id)mutableObjectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error;{
    return [[self objectFromJSONDataWithParseOptions:options error:error] mutableCopy];
}

@end

@implementation NSData (EXEncrypt)

/**
 *  转换成MD5
 *
 *  @return md5的字符串 默认小写
 */
- (NSString *)encodeMD5;{
    return [self encodeMD5Uppercase:NO];
}

/**
 *  转换成MD5
 *
 *  @param uppercase 是否大写
 *
 *  @return md5的字符串
 */
- (NSString *)encodeMD5Uppercase:(BOOL)uppercase;{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return uppercase ? [hash uppercaseString] :[hash lowercaseString];
}

/**
 *  转换成SHA1
 *
 *  @return md5的字符串 默认小写
 */
- (NSString *)encodeSHA1;{
    return [self encodeSHA1Uppercase:NO];
}

/**
 *  转换成SHA1
 *
 *  @param uppercase 是否大写
 *
 *  @return md5的字符串
 */
- (NSString *)encodeSHA1Uppercase:(BOOL)uppercase;{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_SHA1(self.bytes, (CC_LONG)[self length], result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return uppercase ? [hash uppercaseString] :[hash lowercaseString];
}

@end
