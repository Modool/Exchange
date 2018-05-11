//
//  EXExchangeManager+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeManager.h"
#import "EXExchange.h"

@interface EXExchangeManager ()<EXExchangeManager>

@property (nonatomic, strong) NSMutableDictionary<NSString *, EXExchange *> *exchanges;

@end
