//
//  EXWithdraw.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"
#import "EXConstants.h"

@interface EXWithdraw : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, copy, readonly) NSString *address;

@property (nonatomic, assign, readonly) double amount;

@property (nonatomic, assign, readonly) double fee;

@property (nonatomic, assign, readonly) EXWithdrawStatus status;

@property (nonatomic, assign, readonly) NSTimeInterval time;

@end
