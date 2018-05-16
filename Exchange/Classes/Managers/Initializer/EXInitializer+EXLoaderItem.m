//
//  EXInitializer+EXLoaderItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "EXInitializer+EXLoaderItem.h"

@implementation EXInitializer (EXLoaderItem)

- (void)install{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
