//
//  EXProductItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "RACTableSection.h"

@class EXExchange, EXProduct, EXTicker;
@interface EXProductItemViewModel : RACViewModel<RACTableRow>

@property (nonatomic, strong, readonly) EXProduct *product;

@property (nonatomic, strong, readonly) EXTicker *ticker;

@property (nonatomic, strong, readonly) EXExchange *exchange;

@property (nonatomic, strong, readonly) NSAttributedString *symbolAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *exchangeAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *priceAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *legalRendePriceAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *offsetAttributedString;

@property (nonatomic, strong, readonly) NSAttributedString *increasementAttributedString;

@property (nonatomic, strong, readonly) NSString *increaseRatioString;
@property (nonatomic, strong, readonly) UIColor *increaseRatioBackgroundColor;

@property (nonatomic, assign, getter=isCollected) BOOL collected;

- (instancetype)initWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange;

@end
