//
//  EXBalanceCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EXBalanceItemViewModel.h"

@interface EXBalanceCell : UITableViewCell<RACView>

@property (nonatomic, strong, readonly) EXBalanceItemViewModel *viewModel;

@end
