//
//  NSString+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "NSString+EXAdditions.h"

@implementation NSString (EXAdditions)

- (NSString *)encodeSHA256;{
    return [self encodeSHA256Uppercase:NO];
}

- (NSString *)encodeSHA256Uppercase:(BOOL)uppercase;{
    const char *origin = [self UTF8String];
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(origin, (CC_LONG)strlen(origin), buffer);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", buffer[i]];
    }
    return uppercase ? [hash uppercaseString] :[hash lowercaseString];
}

- (NSString *)encodeHmacSHA256WithSceretKey:(NSString *)secretKey;{
    return [self encodeHmacSHA256WithSceretKey:secretKey uppercase:NO];
}

- (NSString *)encodeHmacSHA256WithSceretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;{
    return [self encodeHmacWithAlgorithm:kCCHmacAlgSHA256 secretKey:secretKey uppercase:uppercase];
}

- (NSString *)encodeHmacSHA384WithSceretKey:(NSString *)secretKey;{
    return [self encodeHmacSHA384WithSceretKey:secretKey uppercase:NO];
}

- (NSString *)encodeHmacSHA384WithSceretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;{
    return [self encodeHmacWithAlgorithm:kCCHmacAlgSHA384 secretKey:secretKey uppercase:uppercase];
}

- (NSString *)encodeHmacWithAlgorithm:(CCHmacAlgorithm)algorithm secretKey:(NSString *)secretKey uppercase:(BOOL)uppercase;{
    NSDictionary *sizes = @{@(kCCHmacAlgSHA1): @(CC_SHA1_DIGEST_LENGTH),
                            @(kCCHmacAlgMD5): @(CC_MD5_DIGEST_LENGTH),
                            @(kCCHmacAlgSHA256): @(CC_SHA256_DIGEST_LENGTH),
                            @(kCCHmacAlgSHA384): @(CC_SHA384_DIGEST_LENGTH),
                            @(kCCHmacAlgSHA512): @(CC_SHA512_DIGEST_LENGTH),
                            @(kCCHmacAlgSHA224): @(CC_SHA224_DIGEST_LENGTH)};
    
    const char *key  = [secretKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *origin = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    size_t size = [sizes[@(algorithm)] unsignedIntValue];
    unsigned char *buffer = malloc(size);
    CCHmac(algorithm, key, strlen(key), origin, strlen(origin), buffer);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < size; ++i){
        [hash appendFormat:@"%02X", buffer[i]];
    }
    free(buffer);
    
    return uppercase ? [hash uppercaseString] :[hash lowercaseString];
}

+ (NSString *)stringFromDoubleValue:(double)doubleValue;{
    return [self stringFromNumber:@(doubleValue) numberStyle:NSNumberFormatterDecimalStyle maximumFractionDigits:8];
}

+ (NSString *)stringFromNumber:(NSNumber *)number{
    return [[[NSNumberFormatter alloc] init] stringFromNumber:number];
}

+ (NSString *)stringFromNumber:(NSNumber *)number maximumFractionDigits:(NSUInteger)maximumFractionDigits;{
    return [self stringFromNumber:number numberStyle:NSNumberFormatterDecimalStyle maximumFractionDigits:maximumFractionDigits];
}

+ (NSString *)stringFromNumber:(NSNumber *)number numberStyle:(NSNumberFormatterStyle)numberStyle maximumFractionDigits:(NSUInteger)maximumFractionDigits;{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = numberStyle;
    formatter.maximumFractionDigits = maximumFractionDigits;
    
    return [formatter stringFromNumber:number];
}

@end
