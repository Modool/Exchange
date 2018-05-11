//
//  NSArray+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/24.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "NSArray+EXAdditions.h"
#import "NSDictionary+EXAdditions.h"

@implementation NSArray (EXAdditions)

+ (NSArray *)arrayWithObject:(id)object arguments:(va_list)arguments;{
    if (!object) return nil;
    NSMutableArray *array = [NSMutableArray arrayWithObject:object];
    id value = nil;
    while ((value = va_arg(arguments, id))) {
        [array addObject:value];
    }
    return [array copy];
}

- (NSArray *)arrayByRemovingObject:(id)object;{
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:object];
    
    return [array copy];
}

- (NSArray *)arrayByRemovingObjectsInArray:(NSArray *)objects;{
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInArray:objects];
    
    return [array copy];
}

- (NSArray *)arrayByAddingObject:(id)object;{
    NSMutableArray *array = [self mutableCopy];
    [array addObject:object];
    
    return [array copy];
}

- (NSArray *)arrayByIntersectArray:(NSArray *)otherArray;{
    NSMutableSet *set = [NSMutableSet setWithArray:[self copy]];
    NSSet *otherSet = [NSSet setWithArray:[otherArray copy]];
    [set intersectSet:otherSet];
    
    return [set allObjects];
}

- (NSArray *)arrayByMinusArray:(NSArray *)otherArray;{
    NSMutableSet *set = [NSMutableSet setWithArray:[self copy]];
    
    NSSet *otherSet = [NSSet setWithArray:[otherArray copy]];
    [set minusSet:otherSet];
    
    return [set allObjects];
}

- (NSArray *)arrayByUnionArray:(NSArray *)otherArray;{
    NSMutableSet *set = [NSMutableSet setWithArray:[self copy]];
    NSSet *otherSet = [NSSet setWithArray:[otherArray copy]];
    [set unionSet:otherSet];
    
    return [set allObjects];
}

- (BOOL)intersectsArray:(NSArray *)otherArray;{
    NSSet *set = [NSSet setWithArray:[self copy]];
    NSSet *otherSet = [NSSet setWithArray:[otherArray copy]];
    
    return [set intersectsSet:otherSet];
}

@end

@implementation NSMutableArray (EXAdditions)

- (void)intersectArray:(NSArray *)otherArray;{
    self.array = [self arrayByIntersectArray:otherArray];
}

- (void)minusArray:(NSArray *)otherArray;{
    self.array = [self arrayByMinusArray:otherArray];
}

- (void)unionArray:(NSArray *)otherArray;{
    self.array = [self arrayByUnionArray:otherArray];
}

@end

@implementation NSArray (EXJSONSerializing)

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

@implementation NSArray (RACFilterValue)

- (NSArray *)arrayFilterValue:(id)value;{
    NSMutableArray *array = [NSMutableArray new];
    
    for (id object in self) {
        id result = object;
        
        if ((value && result == value) || (!value && result == [NSNull null])) continue;
        
        if ([result isKindOfClass:[NSArray class]]) {
            result = [result arrayFilterValue:value];
        } else if ([result isKindOfClass:[NSDictionary class]]) {
            result = [result dictionaryFilterValue:value];
        }
        
        [array addObject:result];
    }
    return [array copy];
}

@end
