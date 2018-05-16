//
//  EXConstants.h
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

EX_EXTERN NSString * const EXExchangeErrorDomain;

EX_EXTERN NSString * const EXExchangeBinanceDomain;
EX_EXTERN NSString * const EXExchangeOKExDomain;
EX_EXTERN NSString * const EXExchangeBitfinexDomain;
EX_EXTERN NSString * const EXExchangeHuobiDomain;

EX_EXTERN NSString *EXExchangeNameFromDomain(NSString *domain);

typedef NSString *EXTradeTypeString;
// 限价单(buy/sell)
EX_EXTERN const EXTradeTypeString EXTradeTypeBuyString;
EX_EXTERN const EXTradeTypeString EXTradeTypeSellString;

// 市价单(buy_market/sell_market)
EX_EXTERN const EXTradeTypeString EXTradeTypeMarketBuyString;
EX_EXTERN const EXTradeTypeString EXTradeTypeMarketSellString;

// 市价单(ask/bid)
EX_EXTERN const EXTradeTypeString EXTradeTypeAskString;
EX_EXTERN const EXTradeTypeString EXTradeTypeBidString;

typedef NS_ENUM(NSUInteger, EXTradeType) {
    EXTradeTypeUnknown = 0,
    EXTradeTypeBuy      = 1 << 0,
    EXTradeTypeSell     = 1 << 1,
    EXTradeTypeMarket   = 1 << 2,
};

EX_EXTERN EXTradeType EXTradeTypeFromString(EXTradeTypeString typeString);
EX_EXTERN EXTradeTypeString EXTradeTypeStringFromType(EXTradeType type);

typedef NS_ENUM(NSUInteger, EXChannel) {
    EXChannelTicker,        // ok_sub_spot_#{symbol}_ticker
    EXChannelDepth,         // ok_sub_spot_#{symbol}_depth
    EXChannelLimitDepth,    // ok_sub_spot_#{symbol}_depth_#{size}
    EXChannelTrade,         // ok_sub_spot_#{symbol}_deals
    EXChannelKLine,         // ok_sub_spot_#{symbol}_kline_#{EXKLineTimeRangeTypeString}
    EXChannelOrder,         // ok_sub_spot_#{symbol}_order
    EXChannelBalance,       // ok_sub_spot_#{symbol}_balance
    
    EXChannelLogin,
    EXChannelAddChannel,
};

typedef NSString *EXSocketEvent;

EX_EXTERN const EXSocketEvent EXSocketEventPing;
EX_EXTERN const EXSocketEvent EXSocketEventPong;
EX_EXTERN const EXSocketEvent EXSocketEventAddChannel;
EX_EXTERN const EXSocketEvent EXSocketEventLogin;

typedef NSString *EXChannelString;

EX_EXTERN const EXChannelString EXChannelStringLogin;
EX_EXTERN const EXChannelString EXChannelStringAddChannel;

EX_EXTERN const EXChannelString EXChannelStringTicker;
EX_EXTERN const EXChannelString EXChannelStringDepth;
EX_EXTERN const EXChannelString EXChannelStringLimitDepth;
EX_EXTERN const EXChannelString EXChannelStringTrade;
EX_EXTERN const EXChannelString EXChannelStringKLine;
EX_EXTERN const EXChannelString EXChannelStringOrder;
EX_EXTERN const EXChannelString EXChannelStringBalance;

EX_EXTERN EXChannelString EXChannelStringFromChannel(EXChannel channel);

// 提现状态（-3:撤销中;-2:已撤销;-1:失败;0:等待提现;1:提现中;2:已汇出;3:邮箱确认;4:人工审核中5:等待身份认证）
typedef NS_ENUM(NSInteger, EXWithdrawStatus) {
    EXWithdrawStatusRevoking = -3,
    EXWithdrawStatusRevoked = -2,
    EXWithdrawStatusFailed = -1,
    EXWithdrawStatusWaiting = 0,
    EXWithdrawStatusWithdrawing = 1,
    EXWithdrawStatusWithdrawSuccess = 2,
    EXWithdrawStatusEmailConfirming = 3,
    EXWithdrawStatusReviewing = 4,
    EXWithdrawStatusIdentityAuthenticating = 5,
};

// -1:充值失败;0:等待确认;1:充值成功
typedef NS_ENUM(NSInteger, EXRechargeStatus) {
    EXRechargeStatusFailed = -1,
    EXRechargeStatusConfirming = 0,
    EXRechargeStatusSuccess = 1,
};

typedef NS_ENUM(NSUInteger, EXKLineTimeRangeType) {
    EXKLineTimeRangeTypeMinute1,
    EXKLineTimeRangeTypeMinute3,
    EXKLineTimeRangeTypeMinute5,
    EXKLineTimeRangeTypeMinute15,
    EXKLineTimeRangeTypeMinute30,
    EXKLineTimeRangeTypeHour1,
    EXKLineTimeRangeTypeHour2,
    EXKLineTimeRangeTypeHour4,
    EXKLineTimeRangeTypeHour6,
    EXKLineTimeRangeTypeHour12,
    EXKLineTimeRangeTypeDay1,
    EXKLineTimeRangeTypeDay3,
    EXKLineTimeRangeTypeWeek1,
};

typedef NSString *EXKLineTimeRangeTypeString;
EX_EXTERN EXKLineTimeRangeType EXKLineTimeRangeTypeFromString(EXKLineTimeRangeTypeString string);
EX_EXTERN EXKLineTimeRangeTypeString EXKLineTimeRangeTypeStringFromType(EXKLineTimeRangeType type);

typedef NS_ENUM(NSUInteger, EXBalanceItemType) {
    EXBalanceItemTypeFree,
    EXBalanceItemTypeFreeze,
    EXBalanceItemTypeBorrow,
};

// -1:已撤销  0:未成交  1:部分成交  2:完全成交 3:撤单处理中
typedef NS_ENUM(NSInteger, EXOrderStatus){
    EXOrderStatusRevoke = -1,
    EXOrderStatusUnsettled = 0,
    EXOrderStatusPartUnsettled,
    EXOrderStatusSettled,
    EXOrderStatusRevoking,
};
typedef NSInteger EXRecordStatus;

EX_EXTERN NSString *EXOrderStatusDescription(EXOrderStatus status);

typedef NS_ENUM(NSUInteger, EXExchangeRateType) {
    EXExchangeRateTypeCNY,
    EXExchangeRateTypeTWD,
    EXExchangeRateTypeHKD,
    EXExchangeRateTypeUSD,
};

EX_EXTERN NSString *EXExchangeRateTypeString(EXExchangeRateType type);

EX_EXTERN NSString *EXOKExErrorDescription(NSInteger code);

EX_EXTERN NSString *EXProductID(NSString *domain, NSString *symbol);

EX_EXTERN NSNotificationName EXExchangeDidDoubleClickTabBarItemNotification;

@interface EXConstants : NSObject

@end
