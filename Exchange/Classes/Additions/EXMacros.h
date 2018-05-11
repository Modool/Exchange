//
//  EXMacros.h
//  Exchange
//
//  Created by Jave on 2018/1/8.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#ifndef EXMacros_h
#define EXMacros_h

#define EX_STATIC           static
#define EX_STATIC_INLINE    static inline

#define EX_UNAVAILABLE      __unavailable
#define EX_DEPRECATED       __deprecated

#define EX_ENUM_UNAVAILABLE     EX_UNAVAILABLE
#define EX_ENUM_DEPRECATED      EX_DEPRECATED

#define EX_CLASS_UNAVAILABLE    EX_UNAVAILABLE
#define EX_CLASS_DEPRECATED     EX_DEPRECATED

#define EX_EXTENSION_UNAVAILABLE    EX_UNAVAILABLE
#define EX_EXTENSION_DEPRECATED     EX_DEPRECATED

#define EX_SYSTEM_VERSION           [[[UIDevice currentDevice] systemVersion] floatValue]

#ifdef __cplusplus
#define EX_EXTERN       extern "C" __attribute__((visibility ("default")))
#else
#define EX_EXTERN       extern __attribute__((visibility ("default")))
#endif

#define SELECT(CONDITION, TRUE, FALSE)                ((CONDITION) ? (TRUE) : (FALSE))
#define BETWEEN(VALUE, MIN_VALUE, MAX_VALUE)          ((VALUE) > (MIN_VALUE) && (VALUE) < (MAX_VALUE))
#define BETWEEN_WITH(VALUE, MIN_VALUE, MAX_VALUE)     ((VALUE) >= (MIN_VALUE) && (VALUE) <= (MAX_VALUE))

#ifndef __EX_DEBUG_TOAST__
#define __EX_DEBUG_TOAST__
#ifdef DEBUG
#define EXDebugToast(CONTENT)               dispatch_main_async_safe(^{ [MBProgressHUD showText:CONTENT inView:UIApplication.shareApplication.delegate.window]; })
#else
#define EXDebugToast(CONTENT)               EXDoNothing()
#endif

#endif

#define dispatch_main_sync_safe(BLOCK)          {   if ([NSThread isMainThread]) BLOCK(); \
                                                    else dispatch_sync(dispatch_get_main_queue(), BLOCK); }

#define dispatch_main_async_safe(BLOCK)         {   if ([NSThread isMainThread]) block(); \
                                                    else dispatch_async(dispatch_get_main_queue(), BLOCK); }

#define EXSharedAppDelegate                     ((EXAppDelegate *)[[UIApplication sharedApplication] delegate])

///------
/// Block
///------

typedef void (^EXVoidBlock)(void);
typedef BOOL (^EXBoolBlock)(void);
typedef int  (^EXIntBlock) (void);
typedef id   (^EXIDBlock)  (void);

typedef void (^EXVoidBlock_int)(int);
typedef BOOL (^EXBoolBlock_int)(int);
typedef int  (^EXIntBlock_int) (int);
typedef id   (^EXIDBlock_int)  (int);

typedef void (^EXVoidBlock_string)(NSString *);
typedef BOOL (^EXBoolBlock_string)(NSString *);
typedef int  (^EXIntBlock_string) (NSString *);
typedef id   (^EXIDBlock_string)  (NSString *);

typedef void (^EXVoidBlock_id)(id);
typedef BOOL (^EXBoolBlock_id)(id);
typedef int  (^EXIntBlock_id) (id);
typedef id   (^EXIDBlock_id)  (id);

#endif /* EXMacros_h */

