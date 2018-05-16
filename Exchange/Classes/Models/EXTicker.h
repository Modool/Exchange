//
//  EXTicker.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@interface EXTicker : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

// 开盘价
@property (nonatomic, assign, readonly) double openPrice;

// 收盘
@property (nonatomic, assign, readonly) double closePrice;

// 买一价
@property (nonatomic, assign, readonly) double currentBuyPrice;
// 卖一价
@property (nonatomic, assign, readonly) double currentSellPrice;

// 最高价
@property (nonatomic, assign, readonly) double highestPrice;
// 最低价
@property (nonatomic, assign, readonly) double lowestPrice;

// 最新成交价
@property (nonatomic, assign, readonly) double lastestPrice;

@property (nonatomic, assign, readonly) double offset;

@property (nonatomic, assign, readonly) double dayLowPrice;

@property (nonatomic, assign, readonly) double dayHightPrice;

// 成交量(最近的24小时)
@property (nonatomic, assign, readonly) double volume;

@property (nonatomic, assign, readonly) NSTimeInterval time;

@end
