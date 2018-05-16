//
//  EXTicker+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTicker.h"

@interface EXTicker ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) double openPrice;
@property (nonatomic, assign) double closePrice;

@property (nonatomic, assign) double currentBuyPrice;
@property (nonatomic, assign) double currentSellPrice;

@property (nonatomic, assign) double highestPrice;
@property (nonatomic, assign) double lowestPrice;

@property (nonatomic, assign) double lastestPrice;

@property (nonatomic, assign) double offset;
@property (nonatomic, assign) double dayLowPrice;
@property (nonatomic, assign) double dayHightPrice;

@property (nonatomic, assign) double volume;

@property (nonatomic, assign) NSTimeInterval time;

@end
