//
//  EXDepth.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXModel.h"

@interface EXDepthItem : EXModel

@property (nonatomic, assign, readonly) double volume;

@property (nonatomic, assign, readonly) double price;

@end

@interface EXDepth : EXModel

// 卖方深度
// [vol, price]
@property (nonatomic, copy, readonly) NSArray<EXDepthItem *> *asks;

// 买方深度
@property (nonatomic, copy, readonly) NSArray<EXDepthItem *> *bids;

@end
