//
//  EXEntranceItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXUserItemViewModel.h"

@class EXExchange;
@interface EXEntranceItemViewModel : RACViewModel<EXUserItemViewModel>

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, assign) CGFloat height;

+ (instancetype)viewModelWithExchange:(EXExchange *)exchange;
- (instancetype)initWithExchange:(EXExchange *)exchange;

@end
