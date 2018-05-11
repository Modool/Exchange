//
//  EXProductDetailDepthViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXTrade.h"

@interface EXProductDetailDepthViewModel : RACViewModel

@property (nonatomic, strong, readonly) NSArray<EXTrade *> *trades;

@end
