//
//  EXModel.h
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <YYModel/YYModel.h>

@interface EXModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *objectID;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface NSObject (MDSerialization)

- (id)filterNullObject;

@end

@interface NSDictionary (MDSerialization)

- (id)modelOfClass:(Class)class error:(NSError **)error;

@end

@interface NSArray (MDSerialization)

- (id)modelsOfClass:(Class)class error:(NSError **)error;

@end

