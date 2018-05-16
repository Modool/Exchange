//
//  EXProductBriefItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"
#import "EXProduct.h"

@interface EXProductBriefItemViewModel : RACViewModel

@property (nonatomic, strong, readonly) EXProduct *product;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *basic;

@property (nonatomic, assign) BOOL collected;

+ (instancetype)viewModelWithProduct:(EXProduct *)product;
- (instancetype)initWithProduct:(EXProduct *)product;

@end
