
//
//  RACControllerViewModel+EXHttpClient.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel+EXHttpClient.h"
#import "EXHTTPClient.h"

@implementation RACControllerViewModel (EXHttpClient)

- (id<EXHTTPClient>)clientByExchange:(EXExchange *)exchange;{
    return [EXHTTPClient clientWithExchange:exchange];
}

@end
