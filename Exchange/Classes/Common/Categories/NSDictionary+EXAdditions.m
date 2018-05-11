//
//  NSDictionary+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "NSDictionary+EXAdditions.h"
#import "NSArray+EXAdditions.h"

@implementation NSDictionary (EXAdditions)

+ (NSDictionary *)dictionaryWithKey:(NSString *)key arguments:(va_list)arguments;{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSInteger index = 0;
    id value = nil;
    do {
        if (index % 2) {
            key = va_arg(arguments, NSString *);
            if (!key) break;
        } else {
            value = va_arg(arguments, id);
            dictionary[key] = value ?: [NSNull null];
        }
        index++;
    } while (1);
    
    return [dictionary copy];
}

- (NSDictionary *)dictionaryByAddingDictionary:(NSDictionary *)dictionary;{
    NSMutableDictionary *mutableDictionary = [self mutableCopy];
    [mutableDictionary addEntriesFromDictionary:dictionary];
    
    return [mutableDictionary copy];
}

- (NSDictionary *)dictionaryByRemovingForKeys:(NSArray *)keys;{
    NSMutableDictionary *mutableDictionary = [self mutableCopy];
    [mutableDictionary removeObjectsForKeys:keys];
    
    return [mutableDictionary copy];
}

- (NSDictionary *)dictionaryWithKeys:(NSArray *)keys;{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    for (id key in [self allKeys]) {
        if (![keys containsObject:key]) continue;
        
        dictionary[key] = self[key];
    }
    
    return [dictionary copy];
}

@end

@implementation NSDictionary (EXJSONSerializing)

- (NSData *)JSONData;{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;{
    return [NSJSONSerialization dataWithJSONObject:self options:options error:error];
}
- (NSString *)JSONString;{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;{
    return [[NSString alloc] initWithData:[self JSONDataWithOptions:options error:error] encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (RACFilterValue)

- (NSDictionary *)dictionaryFilterValue:(id)value;{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    for (NSString *key in [self allKeys]) {
        id result = self[key];
        
        if ((value && result == value) || (!value && result == [NSNull null])) continue;
        
        if ([result isKindOfClass:[NSArray class]]) {
            result = [result arrayFilterValue:value];
        } else if ([result isKindOfClass:[NSDictionary class]]) {
            result = [result dictionaryFilterValue:value];
        }
        dictionary[key] = result;
    }
    return [dictionary copy];
}

@end
