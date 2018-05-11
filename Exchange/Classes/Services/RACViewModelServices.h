//
//  RACViewModelServices
//  ThaiynMall
//
//  Created by Marke Jave on 14/12/27.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACNavigationProtocol.h"
#import "RACAppStoreService.h"

@class EXRACHTTPClient;
@protocol RACViewModelServices <NSObject, RACNavigationProtocol>

/// A reference to RACClient instance.
@property (nonatomic, strong) EXRACHTTPClient *client;

@required
@property (nonatomic, strong, readonly) id<RACAppStoreService> appStoreService;

@end
