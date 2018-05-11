//
//  EXTrade.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"
#import "EXConstants.h"

@interface EXTrade : EXModel

@property (nonatomic, assign, readonly) EXTradeType type;

@property (nonatomic, assign, readonly) BOOL buy;
@property (nonatomic, assign, readonly) BOOL market;

@property (nonatomic, assign, readonly) double price;
@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, assign, readonly) NSTimeInterval time;

+ (instancetype)tradeWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time;
- (instancetype)initWithObjectID:(NSString *)objectID price:(double)price amount:(double)amount type:(EXTradeType)type time:(NSTimeInterval)time;

@end
