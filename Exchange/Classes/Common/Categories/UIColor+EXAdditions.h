//
//  UIColor+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __BBLINK_COLOR_IMPORT__
#define __BBLINK_COLOR_IMPORT__

#define HEXCOLOR( hex )                     [UIColor colorWithHexRGB:(hex)]
#define HEXACOLOR( hex )                    [UIColor colorWithHexRGBA:(hex)]
#define HEXCOLOR_ALPHA(hex, a)              [UIColor colorWithHexRGB:(hex) alpha:(a)]

#define EXColor(r, g, b)                    [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]
#define EXColorA(r, g, b, a)                [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

#define EXColor255(r, g, b)                 [UIColor colorWithRed:(r/255.) green:(g/255.) blue:(b/255.) alpha:1.0]
#define EXColor255A(r, g, b, a)             [UIColor colorWithRed:(r/255.) green:(g/255.) blue:(b/255.) alpha:(a)]

#endif

@interface UIColor (EXAdditions)
/**
 *  16进制颜色转换成UIColor
 *
 *  @param  hexValue 16进制颜色（无透明度值）
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGB:(NSUInteger)hexValue;
/**
 *  16进制颜色转换成UIColor
 *
 *  @param  hexValue 16进制颜色（有透明度值）
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGBA:(NSUInteger)hexValue;

/**
 *  16进制颜色转换成UIColor
 *
 *  @param hexValue 16进制颜色
 *  @param alpha    透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGB:(NSUInteger)hexValue alpha:(CGFloat)alpha;

@end
