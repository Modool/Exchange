//
//  EXProductDetailTickerViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailTickerViewModel.h"

#import "EXProductManager.h"

@interface EXProductDetailTickerViewModel ()<EXProductManagerSymbolDelegate>

@property (nonatomic, strong) NSAttributedString *priceAttributedString;

@property (nonatomic, strong) NSAttributedString *increasementAttributedString;

@property (nonatomic, strong) NSAttributedString *volumeAttributedString;

@property (nonatomic, strong) NSAttributedString *highestAttributedString;

@property (nonatomic, strong) NSAttributedString *lowestAttributedString;

@end

@implementation EXProductDetailTickerViewModel

- (instancetype)initWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange;{
    if (self = [super init]) {
        _product = product;
        _exchange = exchange;
//        _ticker = product.ticker;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    [[self rac_willDeallocSignal] subscribeToTarget:self performSelector:@selector(_deregisterDelegate)];
    
    [self _registerDelegate];
    [self _updateAttributedStringsWithTicker:self.ticker];
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

#pragma mark - privagte

- (void)_updateAttributedStringsWithTicker:(EXTicker *)ticker{
    EXProduct *product = self.product;
    EXExchange *exchange = self.exchange;
    
    self.priceAttributedString = [self priceAttributedStringWithProduct:product exchange:exchange ticker:ticker];
    self.increasementAttributedString = [self increasementAttributedStringWithTicker:ticker];
    
    self.volumeAttributedString = [self volumeAttributedStringWithVolume:ticker.volume];
    
    self.highestAttributedString = [self extremePriceAttributedStringWithTitle:@"24H最高" price:ticker.highestPrice];
    self.lowestAttributedString = [self extremePriceAttributedStringWithTitle:@"24H最低" price:ticker.lowestPrice];
}

- (NSAttributedString *)priceAttributedStringWithProduct:(EXProduct *)product exchange:(EXExchange *)exchange ticker:(EXTicker *)ticker{
    if (ticker.lastestPrice <= 0) return nil;
    
    __block double rate = 0;
    [EXProductManager sync:^(EXDelegatesAccessor<EXProductManager> *accessor) {
        rate = [accessor rateByExchange:exchange.domain name:product.name basic:product.basic];
    }];
    double legalRendePrice = rate * ticker.lastestPrice;
    NSString *typeString = EXExchangeRateTypeString(exchange.rateType);
    
    NSString *priceString = fmts(@"%.8f", ticker.lastestPrice);
    NSString *legalRendePriceString = fmts(@"%.2f %@", legalRendePrice, typeString);
    NSString *string = fmts(@"%@  %@", priceString, legalRendePriceString);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length - legalRendePriceString.length, legalRendePriceString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(string.length - legalRendePriceString.length, legalRendePriceString.length)];
    
    return attributedString.copy;
}

- (NSAttributedString *)increasementAttributedStringWithTicker:(EXTicker *)ticker{
    UIColor *color = ticker.offset > 0 ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : (ticker.offset < 0 ? [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00] : [UIColor grayColor]);
    NSString *operator = ticker.offset > 0 ? @"+" : @"-";
    NSString *offsetString = fmts(@"%.8f", fabs(ticker.offset));
    NSString *ratioString = fmts(@"%.8f%%", fabs(ticker.offset / ticker.openPrice * 100));
    NSString *string = fmts(@"%@%@  %@%@", operator, offsetString, operator, ratioString);
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: color}];
}

- (NSAttributedString *)volumeAttributedStringWithVolume:(double)volume{
    NSString *volumeString = volume > 100 ?  fmts(@"%.2f万", volume / 10000) : fmts(@"%.8f", volume);
    NSString *string = fmts(@"24H 成交量  %@", volumeString);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor grayColor]}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(string.length - volumeString.length, volumeString.length)];
    
    return attributedString.copy;
}

- (NSAttributedString *)extremePriceAttributedStringWithTitle:(NSString *)title price:(double)price{
    NSString *priceString = fmts(@"%.8f", price);
    NSString *string = fmts(@"%@  %@", title, priceString);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor grayColor]}];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(string.length - priceString.length, priceString.length)];
    
    return attributedString.copy;
}

#pragma mark - EXProductManagerSymbolDelegate

- (void)productManager:(EXProductManager *)productManager didUpdateTicker:(EXTicker *)ticker forSymbol:(NSString *)symbol;{
    [self _updateAttributedStringsWithTicker:ticker];
    
    _ticker = ticker;
}

@end
