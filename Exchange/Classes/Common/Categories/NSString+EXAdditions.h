//
//  NSString+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <Foundation/Foundation.h>

@interface NSString (EXAdditions)

- (NSString *)encodeSHA256;
- (NSString *)encodeSHA256Uppercase:(BOOL)uppercase;

- (NSString *)encodeHmacSHA256WithSceretKey:(NSString *)secretKey;
- (NSString *)encodeHmacSHA256WithSceretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;

- (NSString *)encodeHmacSHA384WithSceretKey:(NSString *)secretKey;
- (NSString *)encodeHmacSHA384WithSceretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;

- (NSString *)encodeHmacWithAlgorithm:(CCHmacAlgorithm)algorithm secretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;

+ (NSString *)stringFromDoubleValue:(double)doubleValue;

+ (NSString *)stringFromNumber:(NSNumber *)number;
+ (NSString *)stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits;
+ (NSString *)stringFromNumber:(NSNumber *)number numberStyle:(NSNumberFormatterStyle)numberStyle maximumFractionDigits:(NSUInteger)maximumFractionDigits;

@end
