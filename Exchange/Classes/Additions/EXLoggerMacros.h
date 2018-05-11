//
//  EXLoggerMacros.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXUtils.h"

#ifndef EXLoggerMacros_h
#define EXLoggerMacros_h

#if DEBUG
#define EXLog(fmt, ...)     EXLogger(@"%s[line: %d] %s: "fmt, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)
#else
#define EXLog(fmt, ...)     EXDoNothing()
#endif

#define NSParameterAssertReturn(condition, returnValue)             { if (!(condition)) { EXLog(@"Invalid parameter not satisfying: %@", @#condition); return returnValue; }}

#define NSParameterAssertReturnVoid(condition)                      NSParameterAssertReturn(condition, )
#define NSParameterAssertReturnNil(condition)                       NSParameterAssertReturn(condition, nil)
#define NSParameterAssertReturnTrue(condition)                      NSParameterAssertReturn(condition, YES)
#define NSParameterAssertReturnFalse(condition)                     NSParameterAssertReturn(condition, NO)

#endif /* EXLogMacors_h */
