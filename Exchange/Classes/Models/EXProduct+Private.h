//
//  EXProduct+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProduct.h"
#import "EXTicker.h"
#import "EXDepth.h"
#import "EXBalance.h"
#import "EXOrder.h"
#import "EXTrade.h"
#import "EXKLineMetadata.h"

@interface EXProduct ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) double minimumUnit;

@property (nonatomic, assign) double precision;

@property (nonatomic, assign) BOOL collected;

@end
