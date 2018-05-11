//
//  RACViewModelServicesImpl.h
//  ThaiynMall
//
//  Created by Marke Jave on 14/12/27.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACViewModelServices.h"

@interface RACViewModelServicesImpl : NSObject <RACViewModelServices>

- (instancetype)initWithUnauthenticatedClient:(EXRACHTTPClient *)client;

@end
