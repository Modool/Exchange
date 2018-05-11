
//
//  EXTransformMacros.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#ifndef EXTransformMacros_h
#define EXTransformMacros_h

#define keytos(key)                                        ""#key

#define class_name(obj)                                    NSStringFromClass([obj class])

/**
 *  BOOL 转换成NSNumber
 */
#define bton(bool)                                         [NSNumber numberWithBool:bool]

/**
 *  BOOL 转换成NSString
 */
#define btos(bool)                                         [NSString stringWithFormat:@"%d", bool]

/**
 *  NSInteger 转换成NSNumber
 */
#define iton(integer)                                       [NSNumber numberWithInteger:integer]

/**
 *  CGFloat 转换成NSString
 */
#define ftos(flo)                                           [NSString stringWithFormat:@"%f", flo]

/**
 *   string 转换成NSNumber
 */
#define stonb(string)                                       [[[NSNumberFormatter alloc] init] numberFromString:string];

#define EXImageNamed(NAME)                                  EXImageNameFromat(@"%@", NAME)
#define EXImageNameFromat(FORMATE, ...)                     [UIImage imageNamed:[NSString stringWithFormat:FORMATE, ##__VA_ARGS__]]

#define EXClass(CLASS_DEFINE)                               [CLASS_DEFINE class]
#define EXClassName(CLASS_DEFINE)                           NSStringFromClass([CLASS_DEFINE class])

#define EX_K            1024
#define EX_M            (EX_K * EX_K)
#define EX_G            (EX_K * EX_M)
#define EX_T            (EX_K * EX_G)

#define EX_SECOND                   1.f
#define EX_SECONDS_PER_MINUTE       (EX_SECOND * 60)
#define EX_SECONDS_PER_HOUR         (EX_SECONDS_PER_MINUTE * 60)
#define EX_SECONDS_PER_DAY          (EX_SECONDS_PER_HOUR * 24)
#define EX_SECONDS_PER_WEEK         (EX_SECONDS_PER_DAY * 7)

#define EX_MINUTE                   1.f
#define EX_MINUTES_PER_HOUR         (EX_MINUTE * 60)
#define EX_MINUTES_PER_DAY          (EX_MINUTES_PER_HOUR * 24)
#define EX_MINUTES_PER_WEEK         (EX_MINUTES_PER_DAY * 7)

#endif /* EXTransformMacors_h */
