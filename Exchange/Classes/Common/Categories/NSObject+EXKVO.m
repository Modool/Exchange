//
//  NSObject+EXKVO.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <YYModel/YYModel.h>
#import "NSObject+EXKVO.h"

@implementation NSObject (EXKVO)

+ (void)load{
    [self jr_swizzleMethod:@selector(setNilValueForKey:) withMethod:@selector(swizzle_setNilValueForKey:) error:nil];
}

- (void)swizzle_setNilValueForKey:(NSString *)key{
    objc_property_t property = class_getProperty(self.class, key.UTF8String);
    YYClassPropertyInfo *info = [[YYClassPropertyInfo alloc] initWithProperty:property];
    YYEncodingType type = info.type & 0xFF;
    
    if (BETWEEN_WITH(type, YYEncodingTypeBool, YYEncodingTypeLongDouble)) [self setValue:@0 forKey:key];
    else [self swizzle_setNilValueForKey:key];
}

@end
