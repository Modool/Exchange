//
//  NSDictionary+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EXAdditions)

+ (NSDictionary *)dictionaryWithKey:(NSString *)key arguments:(va_list)arguments;

- (NSDictionary *)dictionaryByAddingDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryByRemovingForKeys:(NSArray *)keys;

- (NSDictionary *)dictionaryWithKeys:(NSArray *)keys;

@end

@interface NSDictionary (EXJSONSerializing)

- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;
- (NSString *)JSONString;
- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;

@end

@interface NSDictionary (RACFilterValue)

- (NSDictionary *)dictionaryFilterValue:(id)value;

@end
