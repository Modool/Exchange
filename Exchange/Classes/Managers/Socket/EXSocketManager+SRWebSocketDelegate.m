//
//  EXSocketManager+SRWebSocketDelegate.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSocketManager+SRWebSocketDelegate.h"
#import "EXSocketManager+Private.h"

const NSTimeInterval EXSocketManagerHeatbeatTimeInterval = 30;

@implementation EXSocketResponse

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    EXSocketResponse *response;
    return [[super modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(response, event): @"event",
               @keypath(response, channel): @"channel",
               @keypath(response, code): @"errorcode",
              @keypath(response, data): @"data",
               }];
}

- (void)setCode:(NSUInteger)code{
    if (_code != code) {
        _code = code;
        
        _error = EXOKExErrorDescription(code);
    }
}

@end

@implementation EXSocketManager (SRWebSocketDelegatePrivate)

- (void)_open{
    if (self.socket) return;
    
    self.socket = [[SRWebSocket alloc] initWithURL:self.exchange.webSocketURL];
    self.socket.delegate = self;
    
    [self.socket setDelegateDispatchQueue:self.queue];
    [self.socket open];
}

- (void)_close{
    if (!self.socket) return;
    
    [self _stopHeatbeat];
    
    [self.socket close];
    self.socket = nil;
}

- (void)_reconnect{
    [self _close];
    
    NSTimeInterval timeInterval = self.reconnectTimeInterval;
    if (timeInterval > EX_SECONDS_PER_MINUTE) return;
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self _close];
        [self _open];
    });
    
    self.reconnectTimeInterval *= 2;
}

- (BOOL)_login;{
    NSString *APIKey = self.exchange.APIKey;
    NSString *secretKey = self.exchange.secretKey;
    if (!APIKey.length || !secretKey.length) return NO;
    
    return [self _sendEvent:EXSocketEventLogin parameters:@{@"api_key":ntoe(APIKey), @"sign":ntoe(secretKey)}];
}

- (BOOL)_ping;{
    return [self _sendEvent:EXSocketEventPing];
}

- (void)_startHeatbeat{
    [self _stopHeatbeat];
    
    self.heatbeatTimer = [EXTimer timerWithInterval:EXSocketManagerHeatbeatTimeInterval target:self action:@selector(didHeatbeatTimeout:)];
    [self.heatbeatTimer schedule];
}

- (void)_stopHeatbeat{
    if (!self.heatbeatTimer) return;
    
    [self.heatbeatTimer stop];
    self.heatbeatTimer = nil;
}

- (void)_automaticRegisterChannels{
    NSArray<EXChannelString> *channels = self.channels.copy;
    
    [self _sendToAddChannels:channels];
}

- (BOOL)_sendToAddChannels:(NSArray<EXChannelString> *)channels{
    NSMutableArray<NSDictionary *> *messages = [NSMutableArray array];
    for (EXChannelString channel in channels) {
        [messages addObject:@{@"event": EXSocketEventAddChannel, @"channel": channel}];;
    }
    return [self _sendMessage:messages.JSONString];
}

- (BOOL)_sendToAddChannel:(EXChannelString)channel{
    return [self _sendEvent:EXSocketEventAddChannel channel:channel parameters:nil];
}

- (BOOL)_sendEvent:(EXSocketEvent)event{
    return [self _sendEvent:event parameters:nil];
}
    
- (BOOL)_sendEvent:(EXSocketEvent)event parameters:(NSDictionary *)parameters{
    return [self _sendEvent:event channel:nil parameters:parameters];
}

- (BOOL)_sendEvent:(EXSocketEvent)event channel:(EXChannelString)channel parameters:(NSDictionary *)parameters{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:ntoe(event) forKey:@"event"];
    if ([channel length]) dictionary[@"channel"] = channel;
    if ([parameters count]) dictionary[@"parameters"] = parameters;
    
    return [self _sendMessage:dictionary.JSONString];
}

- (BOOL)_sendMessage:(NSString *)message{
    NSLog(@"Send message: %@", message);
    if (!self.socket) {
        [self _open]; return NO;
    }
    if ([self.socket readyState] != SR_OPEN) return NO;
    
    [self.socket send:message];
    
    return YES;
}

- (void)_receivedResponse:(EXSocketResponse *)response;{
    if (response.code) [self _handleRemoteError:response.error code:response.code];
    else [self _handleResposne:response];
}

- (void)_handleRemoteError:(NSString *)error code:(NSUInteger)code{
    NSLog(@"Did received an error: %@, code: %ld", error, (long)code);
}

- (void)_handleResposne:(EXSocketResponse *)response;{
    NSArray<EXSocketEvent> *events = @[EXSocketEventPing, EXSocketEventPong, EXSocketEventLogin, EXSocketEventAddChannel];
    NSArray<EXChannelString> *channels = @[EXChannelStringLogin, EXChannelStringAddChannel];
    
    if (![events containsObject:response.event] && ![channels containsObject:response.channel]) {
        [self _handleResponseData:response.data forChannel:response.channel];
    } else {
        [self _reduceResponse:response];
    }
}

- (void)_reduceResponse:(EXSocketResponse *)response;{
    if ([response.event isEqualToString:EXSocketEventPong]) {
        [self _receivedPingResponse:response];
    } else if ([response.channel isEqualToString:EXChannelStringLogin]) {
        [self _receivedLoginResponse:response];
    } else if ([response.channel isEqualToString:EXChannelStringAddChannel]) {
        [self _receivedAddChannelResponse:response];
    }
}

- (void)_receivedPingResponse:(EXSocketResponse *)response{
    
}

- (void)_receivedLoginResponse:(EXSocketResponse *)response{
    NSDictionary *data = response.data;
    BOOL success = [data[@"result"] boolValue];
    if (success) [self _respondDelegateLoginSuccessfully];
    else [self _respondDelegateFailedToLoginWithError:[NSError errorWithDomain:EXExchangeOKExDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Failed to login"}]];
}

- (void)_respondDelegateLoginSuccessfully{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(didLoginServerWithSocketManager:)]) {
        [[self delegates] didLoginServerWithSocketManager:self];
    }
}

- (void)_respondDelegateFailedToLoginWithError:(NSError *)error{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(socketManager:failedToLoginServerWithError:)]) {
        [[self delegates] socketManager:self failedToLoginServerWithError:error];
    }
}

- (void)_receivedAddChannelResponse:(EXSocketResponse *)response{
    NSDictionary *data = response.data;
    EXChannelString channel = data[@"channel"];
    BOOL success = [data[@"result"] boolValue];
    
    if (success) [self _respondDelegateSuccessToAddChannel:channel];
    else  [self _respondDelegateFailedToAddChannel:channel error:[NSError errorWithDomain:EXExchangeOKExDomain code:0 userInfo:@{NSLocalizedDescriptionKey: fmts(@"Failed to add channel: %@", channel)}]];
}

- (void)_respondDelegateSuccessToAddChannel:(EXChannelString)channel{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(socketManager:didAddChannel:)]) {
        [[self delegates] socketManager:self didAddChannel:channel];
    }
}

- (void)_respondDelegateFailedToAddChannel:(EXChannelString)channel error:(NSError *)error{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(socketManager:failedToAddChannel:error:)]) {
        [[self delegates] socketManager:self failedToAddChannel:channel error:error];
    }
}

- (void)_handleResponseData:(id)data forChannel:(NSString *)channel{
    if ([[self delegates] hasDelegateThatRespondsToSelector:@selector(socketManager:channel:didReceiveMessage:)]) {
        [[self delegates] socketManager:self channel:channel didReceiveMessage:data];
    }
}

- (IBAction)didHeatbeatTimeout:(id)sender{
    [self _ping];
}

@end

@implementation EXSocketManager (SRWebSocketDelegate)

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;{
    [self _login];
    [self _startHeatbeat];
    [self _automaticRegisterChannels];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;{
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;{
    [self _close];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;{
    NSLog(@"Received message: %@", message);
    id JSON = message.objectFromJSONString;
    if (![JSON isKindOfClass:NSArray.class]) return;
    
    for (NSDictionary *JSONObject in JSON) {
        NSError *error = nil;
        EXSocketResponse *response = [JSONObject modelOfClass:[EXSocketResponse class] error:&error];
        
        if (error) continue;
        [self _receivedResponse:response];
    }
}

@end
