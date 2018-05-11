//
//  EXUtils.m
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <objc/runtime.h>

#import "EXUtils.h"
#import "EXLoggerMacros.h"

@implementation EXUtils

@end

void EXDoNothing(void){}

void EXLogger(NSString *format, ...){
    va_list list;
    va_start(list, format);
    
    NSLogv(format, list);
    
    va_end(list);
}

NSString *EXStringFormat(NSString *format, ...){
    va_list list;
    va_start(list, format);
    
    NSString *string = [[NSString alloc] initWithFormat:format arguments:list];
    
    va_end(list);
    
    return string;
}

void EXMethodSwizzle(Class class, SEL origSel, SEL altSel){
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    
    class_addMethod(class, origSel, class_getMethodImplementation(class, origSel), method_getTypeEncoding(origMethod));
    class_addMethod(class, altSel, class_getMethodImplementation(class, altSel), method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(class, origSel), class_getInstanceMethod(class, altSel));
}

id EXBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

void * EXReverseBoxValue(const char *type, id obj, NSUInteger length) {
    void *value = NULL;
    if (strcmp(type, @encode(id)) == 0) {
        value = (__bridge void *)obj;
    } else if (strcmp(type, @encode(CGPoint)) == 0 ||
               strcmp(type, @encode(CGSize)) == 0 ||
               strcmp(type, @encode(UIEdgeInsets)) == 0 ||
               strcmp(type, @encode(double)) == 0 ||
               strcmp(type, @encode(float)) == 0 ||
               strcmp(type, @encode(int)) == 0 ||
               strcmp(type, @encode(long)) == 0 ||
               strcmp(type, @encode(long long)) == 0 ||
               strcmp(type, @encode(short)) == 0 ||
               strcmp(type, @encode(char)) == 0 ||
               strcmp(type, @encode(bool)) == 0 ||
               strcmp(type, @encode(unsigned char)) == 0 ||
               strcmp(type, @encode(unsigned int)) == 0 ||
               strcmp(type, @encode(unsigned long)) == 0 ||
               strcmp(type, @encode(unsigned long long)) == 0 ||
               strcmp(type, @encode(unsigned short)) == 0) {
        if ([obj isKindOfClass:[NSValue class]]) {
            if (@available(iOS 11, *)) {
                [(NSValue *)obj getValue:&value size:length];
            } else {
                [(NSValue *)obj getValue:&value];
            }
        }
    }
    return value;
}

void EXOnce(dispatch_once_t *predicate, DISPATCH_NOESCAPE dispatch_block_t block){
    NSParameterAssertReturnVoid(predicate);

    if (DISPATCH_EXPECT(*predicate, ~0l) != ~0l) {
        *predicate = ~0l;

        block();
    } else {
        dispatch_compiler_barrier();
    }
    DISPATCH_COMPILER_CAN_ASSUME(*predicate == ~0l);
}

UIImage * EXBundleImage(NSString *bundleIdentifier, NSString *format, ...){
    va_list list;
    va_start(list, format);
    
    NSString *imageName = [[NSString alloc] initWithFormat:format arguments:list];
    
    va_end(list);
    
    return [UIImage imageNamed:imageName inBundle:[NSBundle bundleWithIdentifier:bundleIdentifier] compatibleWithTraitCollection:nil];
}

