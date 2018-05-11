//
//  NSArray+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/24.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(EXAdditions)

+ (NSArray *)arrayWithObject:(id)object arguments:(va_list)arguments;

- (NSArray *)arrayByRemovingObject:(id)object;
- (NSArray *)arrayByRemovingObjectsInArray:(NSArray *)array;
- (NSArray *)arrayByAddingObject:(id)object;

- (NSArray *)arrayByIntersectArray:(NSArray *)otherArray;
- (NSArray *)arrayByMinusArray:(NSArray *)otherArray;
- (NSArray *)arrayByUnionArray:(NSArray *)otherArray;

- (BOOL)intersectsArray:(NSArray *)otherArray;

@end

@interface NSMutableArray (EXAdditions)

- (void)intersectArray:(NSArray *)otherArray;
- (void)minusArray:(NSArray *)otherArray;
- (void)unionArray:(NSArray *)otherArray;

@end

@interface NSArray (EXJSONSerializing)

- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;
- (NSString *)JSONString;
- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;

@end

@interface NSArray (RACFilterValue)

- (NSArray *)arrayFilterValue:(id)value;

@end
