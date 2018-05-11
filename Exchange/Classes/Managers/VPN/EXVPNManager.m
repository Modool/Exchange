//
//  EXVPNManager.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXVPNManager.h"
#import "EXVPNManager+Private.h"

@implementation EXVPNManager

+ (void)sync:(void (^)(EXDelegatesAccessor<EXVPNManager> *accessor))block;{
    [super sync:block];
}

+ (void)async:(void (^)(EXDelegatesAccessor<EXVPNManager> *accessor))block;{
    [super async:block];
}

@end
