//
//  EXDepthItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepthItemViewModel.h"

@implementation EXDepthItemViewModel

- (instancetype)initWithAsk:(EXDepth *)ask bid:(EXDepth *)bid;{
    if (self = [super init]) {
        _ask = ask;
        _bid = bid;
        
        _askPrice = ask.price;
        _askVolume = ask.volume;
        
        _bidPrice = bid.price;
        _bidVolume = bid.volume;
    }
    return self;
}

@end
