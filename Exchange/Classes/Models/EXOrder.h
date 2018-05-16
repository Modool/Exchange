//
//  EXOrder.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"
#import "EXConstants.h"

@interface EXOrder : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *basic;

@property (nonatomic, assign, readonly) EXTradeType type;
@property (nonatomic, assign, readonly) BOOL buy;
@property (nonatomic, assign, readonly) BOOL market;

@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, assign, readonly) double dealAmount;

@property (nonatomic, assign, readonly) double price;

@property (nonatomic, assign, readonly) double unitPrice;
@property (nonatomic, assign, readonly) double averagePrice;

@property (nonatomic, assign, readonly) EXOrderStatus status;

@property (nonatomic, assign, readonly) NSTimeInterval time;

@end
