//
//  RACMacros.h
//  ReactiveCocoa-Extension
//
//  Created by Jave on 2018/1/16.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#ifdef __OBJC__

#import <UIKit/UIKit.h>

#define RACMapArrayCountCondition(condition, input)     ^(id value){ NSParameterAssert(!value || [value isKindOfClass:[NSArray class]]); return @([value ?: @[] count] condition (input)); }

#define RACFilterArrayCountCondition(condition, input)  ^BOOL(id value){ NSParameterAssert(!value || [value isKindOfClass:[NSArray class]]); return ([value ?: @[] count] condition (input)); }

#define RACMapStringLengthCondition(condition, input)   ^(id value){ NSParameterAssert(!value || [value isKindOfClass:[NSString class]]); return @([value length] condition (input)); }

#define RACMapValueForProperty(property)                ^(id value){ return _MASBoxValue(@encode(__typeof__(([value property]))), ([value property])); }

#define RACSignalDefaultNameFormat                      @"%s [line: %d] %s", __FILE__, __LINE__, __FUNCTION__

#endif /* RACMacros_h */
