
//
//  EXOKExHTTPClient+EXWithdraw.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXWithdraw.h"
#import "EXWithdraw.h"
#import "EXAccountRecord.h"

@implementation EXOKExHTTPClient (EXWithdraw)

- (RACSignal *)withdrawWithSymbol:(NSString *)symbol fee:(double)fee password:(NSString *)password address:(NSString *)address amount:(double)amount target:(NSString *)target;{
    NSDictionary *parameters = @{@"symbol": ntoe(symbol), @"chargefee": @(fee), @"trade_pwd": ntoe(password), @"withdraw_address": ntoe(address), @"withdraw_amount": @(amount), @"target": ntoe(target)};
    
    return [self POST:@"/api/v1/withdraw.do" parameters:parameters resultClass:[NSString class] keyPath:@"withdraw_id"];
}

- (RACSignal *)cancelWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;{
    NSDictionary *parameters = @{@"withdraw_id": ntoe(withdrawID), @"symbol": ntoe(symbol)};
    
    return [self POST:@"/api/v1/cancel_withdraw.do" parameters:parameters resultClass:[NSString class] keyPath:@"withdraw_id"];
}

- (RACSignal *)fetchWithdrawInfoWithdrawWithID:(NSString *)withdrawID symbol:(NSString *)symbol;{
    NSDictionary *parameters = @{@"withdraw_id": ntoe(withdrawID), @"symbol": ntoe(symbol)};
    
    return [self POST:@"/api/v1/withdraw_info.do" parameters:parameters resultClass:[EXWithdraw class] keyPath:@"withdraw"];
}

- (RACSignal *)fetchAccountRecordsWithSymbol:(NSString *)symbol withdraw:(BOOL)withdraw page:(NSUInteger)page size:(NSUInteger)size;{
    size = MIN(50, size);
    
    NSDictionary *parameters = @{@"symbol": ntoe(symbol), @"type": @(withdraw), @"current_page": @(page), @"page_length": @(size)};
    
    return [self POST:@"/api/v1/account_records.do" parameters:parameters resultClass:[EXAccountRecord class] keyPath:@"records"];
}

@end
