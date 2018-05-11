//
//  EXSocketManager+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <SocketRocket/SocketRocket.h>
#import "EXSocketManager.h"
#import "EXExchange.h"
#import "EXTimer.h"

#import "EXConstants.h"

@interface EXSocketManager ()<EXSocketManager>

@property (nonatomic, strong, readonly) MDMulticastDelegate<EXSocketManagerDelegate> *delegates;

@property (nonatomic, strong) SRWebSocket *socket;

@property (nonatomic, strong) EXExchange *exchange;

@property (nonatomic, strong) NSMutableSet<EXChannelString> *channels;

@property (nonatomic, assign) NSTimeInterval reconnectTimeInterval;

@property (nonatomic, strong) EXTimer *heatbeatTimer;
           
@end
