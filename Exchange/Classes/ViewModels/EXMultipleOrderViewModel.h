//
//  EXMultipleOrderViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACMultipleViewModel.h"

@interface EXMultipleOrderViewModel : RACMultipleViewModel

@property (nonatomic, strong, readonly) RACCommand *selectProductCommand;

@property (nonatomic, copy, readonly) NSString *rightBarButtonItemTitle;

@end
