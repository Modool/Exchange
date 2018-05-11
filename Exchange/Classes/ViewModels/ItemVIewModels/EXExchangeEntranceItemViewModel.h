//
//  EXExchangeEntranceItemViewModel.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXEntranceItemViewModel.h"
#import "EXUserItemViewModel.h"

@interface EXExchangeEntranceItemViewModel : EXEntranceItemViewModel

@property (nonatomic, copy, readonly) NSString *APIKey;

@property (nonatomic, copy, readonly) NSString *secretKey;

@property (nonatomic, copy, readonly) NSString *rateDescription;

@property (nonatomic, assign, readonly) BOOL automatic;

@property (nonatomic, strong) EXExchange *exchange;

@property (nonatomic, strong) RACCommand *switchCommand;

@end
