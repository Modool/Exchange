//
//  EXConstants.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXConstants.h"

NSString * const EXExchangeErrorDomain = @"com.markejave.exchange.error.domain";

NSString * const EXExchangeBinanceDomain = @"com.binance";
NSString * const EXExchangeOKExDomain = @"com.okex";
NSString * const EXExchangeBitfinexDomain = @"com.bitfinex";
NSString * const EXExchangeHuobiDomain = @"pro.huobi";

NSString *EXExchangeNameFromDomain(NSString *domain){
    static NSDictionary *mapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = @{EXExchangeBinanceDomain: @"币安",
                   EXExchangeOKExDomain: @"OKEx",
                   EXExchangeBitfinexDomain: @"Bitfinex",
                   EXExchangeHuobiDomain: @"火币Pro"};
    });
    return mapper[domain];
}

const EXTradeTypeString EXTradeTypeBuyString = @"buy";
const EXTradeTypeString EXTradeTypeSellString = @"sell";

const EXTradeTypeString EXTradeTypeMarketBuyString = @"buy_market";
const EXTradeTypeString EXTradeTypeMarketSellString = @"sell_market";

const EXTradeTypeString EXTradeTypeAskString = @"ask";
const EXTradeTypeString EXTradeTypeBidString = @"bid";

EXTradeType EXTradeTypeFromString(EXTradeTypeString typeString){
    if ([typeString isEqualToString:EXTradeTypeBuyString]) return EXTradeTypeBuy;
    if ([typeString isEqualToString:EXTradeTypeBidString]) return EXTradeTypeBuy;
    if ([typeString isEqualToString:EXTradeTypeSellString]) return EXTradeTypeSell;
    if ([typeString isEqualToString:EXTradeTypeAskString]) return EXTradeTypeSell;
    if ([typeString isEqualToString:EXTradeTypeMarketBuyString]) return EXTradeTypeBuy | EXTradeTypeMarket;
    if ([typeString isEqualToString:EXTradeTypeMarketSellString]) return EXTradeTypeSell | EXTradeTypeMarket;
    return EXTradeTypeUnknown;
}

EXTradeTypeString EXTradeTypeStringFromType(EXTradeType type){
    if (EXTradeTypeBuy & type) {
        if (type & EXTradeTypeMarket) return EXTradeTypeMarketBuyString;
        else return EXTradeTypeMarketSellString;
    } else if (EXTradeTypeSell & type) {
        if (type & EXTradeTypeMarket) return EXTradeTypeMarketSellString;
        else return EXTradeTypeSellString;
    }
    return nil;
}

NSDictionary *EXKLineTimeRangeTypeDefines(){
    static NSDictionary<NSNumber *, EXKLineTimeRangeTypeString> *typeDefines = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDefines = @{@(EXKLineTimeRangeTypeMinute1): @"1min",
                        @(EXKLineTimeRangeTypeMinute3): @"3min",
                        @(EXKLineTimeRangeTypeMinute5): @"5min",
                        @(EXKLineTimeRangeTypeMinute15): @"15min",
                        @(EXKLineTimeRangeTypeMinute30): @"30min",
                        @(EXKLineTimeRangeTypeHour1): @"1hour",
                        @(EXKLineTimeRangeTypeHour2): @"2hour",
                        @(EXKLineTimeRangeTypeHour4): @"4hour",
                        @(EXKLineTimeRangeTypeHour6): @"6hour",
                        @(EXKLineTimeRangeTypeHour12): @"12hour",
                        @(EXKLineTimeRangeTypeDay1): @"1day",
                        @(EXKLineTimeRangeTypeDay3): @"3day",
                        @(EXKLineTimeRangeTypeWeek1): @"1week"};
    });
    return typeDefines;
}

EXKLineTimeRangeType EXKLineTimeRangeTypeFromString(EXKLineTimeRangeTypeString string){
    return [[[EXKLineTimeRangeTypeDefines() allKeysForObject:string] firstObject] integerValue];
}

EXKLineTimeRangeTypeString EXKLineTimeRangeTypeStringFromType(EXKLineTimeRangeType type){
    return EXKLineTimeRangeTypeDefines()[@(type)];
}

const EXSocketEvent EXSocketEventPing = @"ping";
const EXSocketEvent EXSocketEventPong = @"pong";
const EXSocketEvent EXSocketEventLogin = @"login";
const EXSocketEvent EXSocketEventAddChannel = @"addChannel";

const EXChannelString EXChannelStringLogin = @"login";
const EXChannelString EXChannelStringAddChannel = @"addChannel";

const EXChannelString EXChannelStringTicker = @"ok_sub_spot_%@_ticker";
const EXChannelString EXChannelStringDepth = @"ok_sub_spot_%@_depth";
const EXChannelString EXChannelStringLimitDepth = @"ok_sub_spot_%@_depth_%ld";
const EXChannelString EXChannelStringTrade = @"ok_sub_spot_%@_deals";
const EXChannelString EXChannelStringKLine = @"ok_sub_spot_%@_kline_%@";
const EXChannelString EXChannelStringOrder = @"ok_sub_spot_%@_order";
const EXChannelString EXChannelStringBalance = @"ok_sub_spot_%@_balance";

NSDictionary *EXChannelDefines(){
    static NSDictionary *defines = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defines = @{@(EXChannelTicker): EXChannelStringTicker,
                    @(EXChannelDepth): EXChannelStringDepth,
                    @(EXChannelLimitDepth): EXChannelStringLimitDepth,
                    @(EXChannelTrade): EXChannelStringTrade,
                    @(EXChannelKLine): EXChannelStringKLine,
                    @(EXChannelOrder): EXChannelStringOrder,
                    @(EXChannelBalance): EXChannelStringBalance,
                    @(EXChannelLogin): EXChannelStringLogin,
                    @(EXChannelAddChannel): EXChannelStringAddChannel};
    });
    return defines;
}

EXChannelString EXChannelStringFromChannel(EXChannel channel){
    return EXChannelDefines()[@(channel)];
}

NSString *EXOrderStatusDescription(EXOrderStatus status){
    switch (status) {
        case EXOrderStatusRevoke: return @"已撤回";
        case EXOrderStatusUnsettled: return @"未成交";
        case EXOrderStatusPartUnsettled: return @"部分成交";
        case EXOrderStatusSettled: return @"完全成交";
        case EXOrderStatusRevoking: return @"正在撤回";
        default: return @"未知状态";
    }
}

NSString *EXExchangeRateTypeString(EXExchangeRateType type){
    switch (type) {
        case EXExchangeRateTypeCNY: return @"CNY";
        case EXExchangeRateTypeTWD: return @"TWD";
        case EXExchangeRateTypeHKD: return @"HKD";
        case EXExchangeRateTypeUSD: return @"USD";
        default: return nil;
    }
}

NSString *EXOKExErrorDescription(NSInteger code){
    static NSDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"okex_error_code" withExtension:@"plist"]];
    });
    return dictionary[@(code)];
}

NSString *EXProductID(NSString *domain, NSString *symbol){
    return fmts(@"%@_%@", domain, symbol);
}

NSNotificationName EXExchangeDidDoubleClickTabBarItemNotification = @"EXExchangeDidDoubleClickTabBarItemNotification";

@implementation EXConstants

@end
