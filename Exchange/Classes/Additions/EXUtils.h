//
//  EXUtils.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXMacros.h"

@interface EXUtils : NSObject

@end

EX_EXTERN void EXDoNothing(void);

EX_EXTERN void EXLogger(NSString *format, ...);
EX_EXTERN NSString *EXStringFormat(NSString *format, ...);

EX_EXTERN void EXMethodSwizzle(Class class, SEL origSel, SEL altSel);

EX_EXTERN id EXBoxValue(const char *type, ...);
EX_EXTERN void * EXReverseBoxValue(const char *type, id obj, NSUInteger length);

EX_EXTERN void EXOnce(dispatch_once_t *predicate, dispatch_block_t block);

EX_EXTERN UIImage * EXBundleImage(NSString *bundleIdentifier, NSString *format, ...);

