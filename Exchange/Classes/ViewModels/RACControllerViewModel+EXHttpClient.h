//
//  RACControllerViewModel+EXHttpClient.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"

@class EXExchange;
@protocol EXHTTPClient;
@interface RACControllerViewModel (EXHttpClient)

- (id<EXHTTPClient>)clientByExchange:(EXExchange *)exchange;

@end
