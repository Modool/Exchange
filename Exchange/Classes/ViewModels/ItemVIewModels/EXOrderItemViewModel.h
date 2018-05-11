//
//  EXOrderItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXOrder.h"

@interface EXOrderItemViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXOrder *order;

@property (nonatomic, copy, readonly) NSString *orderID;

@property (nonatomic, copy, readonly) NSString *from;
@property (nonatomic, copy, readonly) NSString *to;

@property (nonatomic, assign, readonly) EXTradeType type;

@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, assign, readonly) double dealAmount;

@property (nonatomic, assign, readonly) double price;

@property (nonatomic, assign, readonly) double dealPrice;

@property (nonatomic, assign, readonly) double averagePrice;

@property (nonatomic, assign, readonly) EXOrderStatus status;

@property (nonatomic, assign, readonly) NSTimeInterval time;

+ (instancetype)viewModelWithOrder:(EXOrder *)order;
- (instancetype)initWithOrder:(EXOrder *)order;

@end
