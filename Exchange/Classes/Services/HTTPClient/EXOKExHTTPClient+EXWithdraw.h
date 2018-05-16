//
//  EXOKExHTTPClient+EXWithdraw.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"

@interface EXOKExHTTPClient (EXWithdraw)<EXHTTPClientWithdraw>

/**
 提币

 @param symbol 币对
 @param fee 网络手续费 >=0 BTC范围 [0.002，0.005] LTC范围 [0.001，0.2] ETH范围 [0.01] ETC范围 [0.0001，0.2] BCH范围 [0.0005，0.002] 手续费越高，网络确认越快，向OKCoin提币设置为0
 @param password 交易密码
 @param address 认证的地址、邮箱或手机号码
 @param amount 提币数量 BTC>=0.01 LTC>=0.1 ETH>=0.1 ETC>=0.1 BCH>=0.1
 @param target 地址类型 okcn：国内站 okcom：国际站 okex：OKEX address：外部地址
 @return result: withdraw id
 */
- (RACSignal *)withdrawWithSymbol:(NSString *)symbol fee:(double)fee password:(NSString *)password address:(NSString *)address amount:(double)amount target:(NSString *)target;

// result: withdraw id
- (RACSignal *)cancelWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;

// result: EXWithdraw
- (RACSignal *)fetchWithdrawInfoWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;

// result: list of EXAccountRecord
- (RACSignal *)fetchAccountRecordsWithSymbol:(NSString *)symbol withdraw:(BOOL)withdraw page:(NSUInteger)page size:(NSUInteger)size;

@end
