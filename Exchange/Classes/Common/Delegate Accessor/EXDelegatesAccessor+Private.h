//
//  EXDelegatesAccessor+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/20.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@protocol EXDelegatesAccessorPrivate <EXDelegatesAccessor>

+ (instancetype)sharedAccessor;

@end

@interface EXDelegatesAccessor (Private)<EXDelegatesAccessorPrivate>

@end
