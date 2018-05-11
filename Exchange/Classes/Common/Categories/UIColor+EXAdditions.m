//
//  UIColor+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "UIColor+EXAdditions.h"

@implementation UIColor (EXAdditions)

/**
 *  16进制颜色转换成UIColor
 *
 *  @param hexValue 16进制颜色
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGB:(NSUInteger)hexValue{
    return [self colorWithHexRGB:hexValue alpha:1];
}
/**
 *  16进制颜色转换成UIColor
 *
 *  @param hexValue 16进制颜色
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGBA:(NSUInteger)hexValue{
    return [self colorWithHexRGB:hexValue alpha:((hexValue >> 24) & 0x000000FF)/255.0f];
}
/**
 *  16进制颜色转换成UIColor
 *
 *  @param hexValue 16进制颜色
 *  @param alpha    透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexRGB:(NSUInteger)hexValue alpha:(CGFloat)alpha;{
    CGFloat red = ((hexValue >> 16) & 0x000000FF)/255.0;
    CGFloat green = ((hexValue >> 8) & 0x000000FF)/255.0f;
    CGFloat blue = ((hexValue) & 0x000000FF)/255.0f;

    return [self colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
