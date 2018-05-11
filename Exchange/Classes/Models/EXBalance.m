//
//  EXBalance.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalance.h"
#import "EXBalance+Private.h"

@implementation EXBalance

- (double)all{
    return _free + _freezed + _borrow;
}

- (BOOL)isZero{
    return self.all == 0;
}

@end
