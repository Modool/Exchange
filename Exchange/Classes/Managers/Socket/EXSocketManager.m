//
//  EXSocketManager.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSocketManager.h"
#import "EXSocketManager+Private.h"
#import "EXSocketManager+SRWebSocketDelegate.h"

#import "EXExchange.h"

@implementation EXSocketManager
@dynamic delegates;

+ (void)async:(void (^)(EXDelegatesAccessor<EXSocketManager> *accessor))block;{
    [super async:block];
}

+ (void)sync:(void (^)(EXDelegatesAccessor<EXSocketManager> *accessor))block;{
    [super sync:block];
}

- (BOOL)isConnected;{
    SRReadyState state = self.socket.readyState;
    
    return state == SR_OPEN;
}

- (void)open;{
    [self _open];
}

- (void)close;{
    [self _close];
}

- (BOOL)loginWithExchange:(EXExchange *)exchange;{
    NSParameterAssert(exchange);
    _exchange = exchange;
    
    return [self _login];
}

- (BOOL)ping;{
    return [self _ping];
}

- (BOOL)addTickerChannelWithSymbol:(NSString *)symbol;{
    return [self addChannel:EXChannelTicker, symbol, nil];
}

- (BOOL)addTradeChannelWithSymbol:(NSString *)symbol;{
    return [self addChannel:EXChannelTrade, symbol, nil];
}

- (BOOL)addDepthChannelWithSymbol:(NSString *)symbol;{
    return [self addChannel:EXChannelDepth, symbol, nil];
}

- (BOOL)addDepthChannelWithSymbol:(NSString *)symbol limit:(NSUInteger)limit;{
    return [self addChannel:EXChannelLimitDepth, symbol, limit, nil];
}

- (BOOL)addKLineChannelWithSymbol:(NSString *)symbol type:(EXKLineTimeRangeType)type;{
    EXKLineTimeRangeTypeString string = EXKLineTimeRangeTypeStringFromType(type);
    
    return [self addChannel:EXChannelKLine, symbol, string, nil];
}

- (BOOL)addOrderChannelWithSymbol:(NSString *)symbol;{
    return [self addChannel:EXChannelOrder, symbol, nil];
}

- (BOOL)addBalanceChannelWithSymbol:(NSString *)symbol;{
    return [self addChannel:EXChannelBalance, symbol, nil];
}

- (BOOL)addChannel:(EXChannel)channel, ...;{
    if (channel == EXChannelLogin || channel == EXChannelAddChannel) return NO;
    
    NSString *format = EXChannelStringFromChannel(channel);
    if (![format length]) return NO;
    
    va_list arguments;
    va_start(arguments, channel);
    
    EXChannelString channelName = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
    return [self addChannelWithName:channelName];
}

- (BOOL)addChannelWithName:(EXChannelString)name;{
    if ([self.channels containsObject:name]) return NO;
    
    [[self channels] addObject:name];
    return [self _sendToAddChannel:name];
}

- (BOOL)addChannelsWithNames:(NSArray<EXChannelString> *)names;{
    NSMutableSet *set = [NSMutableSet setWithArray:names];
    [set minusSet:self.channels];
    
    if (!set.count) return NO;
    
    [[self channels] unionSet:set];
    return [self _sendToAddChannels:set.allObjects];
}

@end
