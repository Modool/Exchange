//
//  EXBalance+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalance.h"

@interface EXBalance ()

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeDomain;

@property (nonatomic, assign) double borrow;

@property (nonatomic, assign) double free;

@property (nonatomic, assign) double freezed;

@end
