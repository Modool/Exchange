//
//  EXOKExHTTPClient+EXUser.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"

@interface EXOKExHTTPClient (EXUser)<EXHTTPClientUser>

// result: EXUser
- (RACSignal *)fetchBalancesSignal;

@end
