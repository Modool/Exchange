//
//  EXBalance.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@interface EXBalance : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, assign, readonly) double borrow;

@property (nonatomic, assign, readonly) double free;

@property (nonatomic, assign, readonly) double freezed;

@property (nonatomic, assign, readonly) double all;
@property (nonatomic, assign, readonly, getter=isZero) BOOL zero;

@end
