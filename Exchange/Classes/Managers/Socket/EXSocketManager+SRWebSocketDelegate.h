//
//  EXSocketManager+SRWebSocketDelegate.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSocketManager+Private.h"
#import "EXModel.h"

@interface EXSocketResponse : EXModel

@property (nonatomic, copy) id data;

@property (nonatomic, copy) NSString *event;
@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *error;

@property (nonatomic, assign) NSUInteger code;

@end

@interface EXSocketManager (SRWebSocketDelegatePrivate)

- (void)_open;
- (void)_close;
- (void)_reconnect;

- (BOOL)_login;
- (BOOL)_ping;

- (void)_startHeatbeat;
- (void)_stopHeatbeat;

- (BOOL)_sendToAddChannels:(NSArray<EXChannelString> *)channels;
- (BOOL)_sendToAddChannel:(EXChannelString)channel;
- (BOOL)_sendEvent:(EXSocketEvent)event parameters:(NSDictionary *)parameters;
- (BOOL)_sendEvent:(EXSocketEvent)event channel:(EXChannelString)channel parameters:(NSDictionary *)parameters;

- (void)_receivedResponse:(EXSocketResponse *)response;

@end

@interface EXSocketManager (SRWebSocketDelegate)<SRWebSocketDelegate>

@end
