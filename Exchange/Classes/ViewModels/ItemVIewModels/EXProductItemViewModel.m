//
//  EXProductItemViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductItemViewModel.h"
#import "EXExchangeManager.h"

#import "EXExchange.h"
#import "EXProduct.h"
#import "EXTicker.h"

#import "EXProductManager.h"

@interface EXProductItemViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) EXProduct *product;

@property (nonatomic, strong) id<EXHTTPClient> client;

@property (nonatomic, strong) NSAttributedString *exchangeAttributedString;
@property (nonatomic, strong) NSAttributedString *priceAttributedString;
@property (nonatomic, strong) NSAttributedString *legalRendePriceAttributedString;
@property (nonatomic, strong) NSAttributedString *offsetAttributedString;
@property (nonatomic, strong) NSAttributedString *increasementAttributedString;
@property (nonatomic, strong) NSString *increaseRatioString;
@property (nonatomic, strong) UIColor *increaseRatioBackgroundColor;

@end

@implementation EXProductItemViewModel

- (instancetype)initWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange;{
    if (self = [super init]) {
        _product = product;
        _exchange = exchange;
        
        __block EXTicker *ticker = nil;
        [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
            ticker = [accessor tickerByExchange:exchange.domain symbol:product.symbol];
        }];
        
        _ticker = ticker;
        _client = exchange.client;
        _collected = product.collected;
        _symbolAttributedString = [self symbolAttributedStringWithProduct:product];
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    
    [self _registerDelegate];
    [self _updateAttributedStringsWithTicker:self.ticker increasement:0];
}

#pragma mark - private

- (void)_registerDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor addDelegate:self delegateQueue:dispatch_get_main_queue() forProductID:self.product.objectID];
    }];
}

- (void)_deregisterDelegate{
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        [accessor removeDelegate:self delegateQueue:dispatch_get_main_queue() forProductID:self.product.objectID];
    }];
}

- (void)_updateAttributedStringsWithTicker:(EXTicker *)ticker increasement:(double)increasement{
    EXProduct *product = self.product;
    EXExchange *exchange = self.exchange;
    
    self.legalRendePriceAttributedString = [self legalRendePriceAttributedStringWithProduct:product exchange:exchange ticker:ticker];
    self.priceAttributedString = [self priceAttributedStringWithProduct:product ticker:ticker];
    self.exchangeAttributedString = [self exchangeAttributedStringWithExchange:exchange ticker:ticker];
    
    double ratio = ticker.openPrice <= 0 ? 0 : (ticker.offset / ticker.openPrice);
    self.increaseRatioString = [self increaseRatioStringWithRatio:ratio];
    self.increaseRatioBackgroundColor = [self increaseRatioBackgroundColorWithRatio:ratio];
    
    self.offsetAttributedString = [self offsetAttributedStringWithOffset:ticker.offset];
    self.increasementAttributedString = [self increasementAttributedStringWithIncreasement:increasement];
    
}

- (NSAttributedString *)symbolAttributedStringWithProduct:(EXProduct *)product{
    NSString *symbol = fmts(@"%@/%@", product.name.uppercaseString, product.basic.uppercaseString);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:symbol];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(product.name.length, product.basic.length + 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(product.name.length, product.basic.length + 1)];
    
    return attributedString.copy;
}

- (NSAttributedString *)legalRendePriceAttributedStringWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange ticker:(EXTicker *)ticker{
    if (ticker.lastestPrice <= 0) return nil;
    
    __block double rate = 0;
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        rate = [accessor rateByExchange:product.exchangeDomain name:product.name basic:product.basic];
    }];
    if (rate == 0) return nil;
    
    double legalRendePrice = rate * ticker.lastestPrice;
    NSString *typeString = EXExchangeRateTypeString(exchange.rateType);
    NSString *string = fmts(@"%@ %@", [NSString stringFromDoubleValue:legalRendePrice], typeString);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(string.length - typeString.length, typeString.length)];
    
    return attributedString.copy;
}

- (NSAttributedString *)priceAttributedStringWithProduct:(EXProduct *)product ticker:(EXTicker *)ticker{
    if (ticker.lastestPrice <= 0) return nil;
    
    NSString *basic = product.basic;
    NSString *string = fmts(@"%@ %@", [NSString stringFromDoubleValue:ticker.lastestPrice], basic.uppercaseString);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(string.length - basic.length, basic.length)];
    
    return attributedString.copy;
}

- (NSAttributedString *)exchangeAttributedStringWithExchange:(EXExchange *)exchange ticker:(EXTicker *)ticker{
    double vol = ticker.volume;
    NSString *volumeString = nil;
    if (vol > 10000) volumeString = fmts(@"量:%.2f万", vol / 10000);
    else if (vol > 0) volumeString = fmts(@"量:%.2f", vol);
    
    return [[NSAttributedString alloc] initWithString:fmts(@"%@ %@", exchange.name, ntoe(volumeString))];
}

- (NSAttributedString *)offsetAttributedStringWithOffset:(double)offset{
    if (offset == 0) return nil;
    
    NSString *string = fmts(@"D: %@%.8f", offset < 0 ? @"-" : @"+", fabs(offset));
    UIColor *color = offset > 0 ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : (offset < 0 ? [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00] : [UIColor grayColor]);
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
}

- (NSAttributedString *)increasementAttributedStringWithIncreasement:(double)increasement{
    if (increasement == 0) return nil;
    
    NSString *string = fmts(@"N: %@%.8f", increasement < 0 ? @"-" : @"+", fabs(increasement));
    UIColor *color = increasement > 0 ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : (increasement < 0 ? [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00] : [UIColor grayColor]);
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
}

- (NSString *)increaseRatioStringWithRatio:(double)ratio{
    if (ratio == 0) return @"---";
    return fmts(@"%@%.2f%%", ratio < 0 ? @"-" : @"+", fabs(ratio * 100));
}

- (UIColor *)increaseRatioBackgroundColorWithRatio:(double)ratio{
    return ratio > 0 ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : (ratio < 0 ? [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00] : [UIColor grayColor]);
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateProduct:(EXProduct *)product collected:(BOOL)collected;{
    self.collected = collected;
    self.product = product;
}

- (void)productManager:(EXProductManager *)productManager productID:(NSString *)productID didUpdateTicker:(EXTicker *)ticker;{
    [self _updateAttributedStringsWithTicker:ticker increasement:ticker.offset - self.ticker.offset];
    
    _ticker = ticker;
}

@end
