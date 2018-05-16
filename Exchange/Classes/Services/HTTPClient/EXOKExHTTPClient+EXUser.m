//
//  EXOKExHTTPClient+EXUser.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOKExHTTPClient+EXUser.h"
#import "EXBalance.h"

@implementation EXOKExHTTPClient (EXUser)

- (RACSignal *)fetchBalancesSignal;{
    return [self POST:@"/api/v1/userinfo.do" parameters:nil resultClass:[NSDictionary class] keyPath:@"info.funds"];
}

@end
