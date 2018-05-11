//
//  EXVPNManager.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDelegatesAccessor.h"

@class EXVPNManager;
@protocol EXVPNManagerDelegate <NSObject>

- (void)VPNManager:(EXVPNManager *)VPNManager didConnectServer:(id)server;

@end

@protocol EXVPNManager <NSObject>

@end

@interface EXVPNManager : EXDelegatesAccessor

+ (void)sync:(void (^)(EXDelegatesAccessor<EXVPNManager> *accessor))block;
+ (void)async:(void (^)(EXDelegatesAccessor<EXVPNManager> *accessor))block;

@end
