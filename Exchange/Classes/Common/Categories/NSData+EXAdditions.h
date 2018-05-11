//
//  NSData+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EXJSONSerializing)

// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;
- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options;
- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error;
- (id)mutableObjectFromJSONData;
- (id)mutableObjectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options;
- (id)mutableObjectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error;

@end

@interface NSData (EXEncrypt)

/**
 *  转换成MD5
 *
 *  @return md5的字符串 默认小写
 */
- (NSString *)encodeMD5;

/**
 *  转换成MD5
 *
 *  @param uppercase 是否大写
 *
 *  @return md5的字符串
 */
- (NSString *)encodeMD5Uppercase:(BOOL)uppercase;

/**
 *  转换成SHA1
 *
 *  @return md5的字符串 默认小写
 */
- (NSString *)encodeSHA1;

/**
 *  转换成SHA1
 *
 *  @param uppercase 是否大写
 *
 *  @return md5的字符串
 */
- (NSString *)encodeSHA1Uppercase:(BOOL)uppercase;

@end
