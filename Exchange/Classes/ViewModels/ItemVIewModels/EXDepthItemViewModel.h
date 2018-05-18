//
//  EXDepthItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXDepth.h"

@interface EXDepthItemViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXDepth *ask;
@property (nonatomic, strong, readonly) EXDepth *bid;

@property (nonatomic, assign, readonly) double askPrice;
@property (nonatomic, assign, readonly) double askVolume;

@property (nonatomic, assign, readonly) double bidPrice;
@property (nonatomic, assign, readonly) double bidVolume;

- (instancetype)initWithAsk:(EXDepth *)ask bid:(EXDepth *)bid;

@end
