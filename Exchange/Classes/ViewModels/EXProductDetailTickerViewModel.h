//
//  EXProductDetailTickerViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"

#import "EXTicker.h"
#import "EXProduct.h"
#import "EXExchange.h"

@interface EXProductDetailTickerViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXProduct *product;
@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) EXTicker *ticker;

@property (nonatomic, strong, readonly) NSAttributedString *priceAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *increasementAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *volumeAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *highestAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *lowestAttributedString;

- (instancetype)initWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange;

@end
