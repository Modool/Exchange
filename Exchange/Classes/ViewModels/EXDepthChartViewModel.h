//
//  EXDepthChartViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"
#import "EXProduct.h"
#import "EXExchange.h"
#import "EXDepth.h"

@interface EXDepthChartViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) EXProduct *product;
@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) RACTwoTuple<NSArray<EXDepth *> *, NSArray<EXDepth *> *> *tuple;

@property (nonatomic, strong) UIBezierPath *askBezierPath;
@property (nonatomic, strong) UIBezierPath *bidBezierPath;

@property (nonatomic, assign) double minimumPrice;
@property (nonatomic, assign) double maximumPrice;

@property (nonatomic, assign) double minimumVolume;

@end
