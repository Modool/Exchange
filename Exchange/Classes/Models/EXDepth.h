//
//  EXDepth.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@interface EXDepth : EXModel

@property (nonatomic, copy, readonly) NSString *productID;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *exchangeDomain;

@property (nonatomic, assign, readonly) double volume;

@property (nonatomic, assign, readonly) double price;

@property (nonatomic, assign, readonly) BOOL buy;

@end

@interface EXDepthSet : EXModel

// 卖方深度
// [vol, price]
@property (nonatomic, copy, readonly) NSArray<EXDepth *> *asks;

// 买方深度
@property (nonatomic, copy, readonly) NSArray<EXDepth *> *bids;

@end
