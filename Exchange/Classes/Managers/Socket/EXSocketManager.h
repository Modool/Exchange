//
//  EXSocketManager.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"
#import "EXConstants.h"

@class EXSocketManager, EXExchange;
@protocol EXSocketManagerDelegate <NSObject>

@optional
- (void)didLoginServerWithSocketManager:(EXSocketManager *)socketManager;
- (void)socketManager:(EXSocketManager *)socketManager failedToLoginServerWithError:(NSError *)error;

- (void)socketManager:(EXSocketManager *)socketManager didAddChannel:(EXChannelString)channel;
- (void)socketManager:(EXSocketManager *)socketManager failedToAddChannel:(EXChannelString)channel error:(NSError *)error;

- (void)socketManager:(EXSocketManager *)socketManager channel:(EXChannelString)channel didReceiveMessage:(id)message;

@end

@protocol EXSocketManager <NSObject>

@property (nonatomic, strong, readonly) EXExchange *exchange;

- (BOOL)isConnected;

- (void)open;
- (void)close;

- (BOOL)loginWithExchange:(EXExchange *)exchange;
- (BOOL)ping;

- (BOOL)addTickerChannelWithSymbol:(NSString *)symbol;
- (BOOL)addTradeChannelWithSymbol:(NSString *)symbol;
- (BOOL)addDepthChannelWithSymbol:(NSString *)symbol;
- (BOOL)addDepthChannelWithSymbol:(NSString *)symbol limit:(NSUInteger)limit;
- (BOOL)addKLineChannelWithSymbol:(NSString *)symbol type:(EXKLineTimeRangeType)type;
- (BOOL)addOrderChannelWithSymbol:(NSString *)symbol;
- (BOOL)addBalanceChannelWithSymbol:(NSString *)symbol;
- (BOOL)addChannel:(EXChannel)channel, ...;
- (BOOL)addChannelWithName:(NSString *)name;
- (BOOL)addChannelsWithNames:(NSArray<NSString *> *)names;

@end

@interface EXSocketManager : EXDelegatesAccessor

@property (nonatomic, strong, readonly) EXExchange *exchange;

+ (void)async:(void (^)(EXDelegatesAccessor<EXSocketManager> *accessor))block;
+ (void)sync:(void (^)(EXDelegatesAccessor<EXSocketManager> *accessor))block;

@end
