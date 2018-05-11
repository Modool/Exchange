
//
//  EXModel.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXModel.h"

@implementation EXModel

+ (NSInteger)version {
    return 1;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;{
    return [self yy_modelWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;{
    if (self = [super init]) {
        [self yy_modelSetWithDictionary:dictionary];
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if ([super isEqual:object]) return YES;
    if (self == object) return YES;
    if (![object isKindOfClass:[EXModel class]]) return NO;
    return [[object objectID] isEqual:[self objectID]];
}

- (NSUInteger)hash{
    return [[self objectID] hash];
}

- (NSString *)description{
    return [self yy_modelDescription];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone{
    return [self yy_modelCopy];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:self.class];
    NSMutableDictionary<NSString *, NSString *> *properties = [NSMutableDictionary dictionary];
    EXModel *sample;
    
    while (classInfo.cls != EXModel.class) {
        NSDictionary<NSString *, YYClassPropertyInfo *> *propertyInfos = classInfo.propertyInfos;
        NSDictionary<NSString *, NSString *> *classProperties = [NSDictionary dictionaryWithObjects:propertyInfos.allKeys forKeys:propertyInfos.allKeys];
        [properties addEntriesFromDictionary:classProperties];
        
        classInfo = classInfo.superClassInfo;
        
        if (classInfo.cls == EXModel.class) {
            properties[@keypath(sample, objectID)] = @keypath(sample, objectID);
        }
    }
    return properties.copy;
}

@end

@implementation NSObject (MDSerialization)

- (id)filterNullObject{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self;
}

- (id)modelOfClass:(Class)class error:(NSError **)error;{
    return nil;
}

- (id)modelsOfClass:(Class)class error:(NSError **)error;{
    return nil;
}

@end

@implementation NSDictionary (MDSerialization)

- (id)filterNullObject;{
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    for (NSString *key in [self allKeys]) {
        id value = self[key];
        
        if (value != [NSNull null]) {
            id filterObject = [value filterNullObject];
            if (filterObject) {
                results[key] = filterObject;
            }
        }
    }
    return results;
}

- (id)modelOfClass:(Class)class error:(NSError **)error;{
    return [class modelWithDictionary:self];
}

@end

@implementation NSArray (MDSerialization)

- (id)filterNullObject;{
    NSMutableArray *results = [NSMutableArray array];
    for (id item in self) {
        if (item != [NSNull null]) {
            id filterObject = [item filterNullObject];
            if (filterObject) {
                [results addObject:filterObject];
            }
        }
    }
    return results;
}

- (id)modelsOfClass:(Class)class error:(NSError **)error;{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dictionary in self) {
        [models addObject:[class modelWithDictionary:dictionary]];
    }
    return models.copy;
}

@end
