//
//  EXAccountRecord.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"
#import "EXConstants.h"

@interface EXAccountRecord : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

// 地址
@property (nonatomic, copy, readonly) NSString *address;

// 账户名称
@property (nonatomic, copy, readonly) NSString *account;

// 银行
@property (nonatomic, copy, readonly) NSString *bank;

// 收款地址
@property (nonatomic, copy, readonly) NSString *benificiaryAddress;

// 提现扣除手续费后金额
@property (nonatomic, assign, readonly) double transactionValue;

// 手续费
@property (nonatomic, assign, readonly) double fee;

// 金额
@property (nonatomic, assign, readonly) double amount;

// 记录状态
@property (nonatomic, assign, readonly) EXRecordStatus status;

// 时间
@property (nonatomic, assign, readonly) NSTimeInterval time;

@end
