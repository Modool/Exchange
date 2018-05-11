//
//  EXUnfinishedOrderCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXUnfinishedOrderItemViewModel.h"

@interface EXUnfinishedOrderCell : UITableViewCell

@property (nonatomic, strong, readonly) EXUnfinishedOrderItemViewModel *viewModel;

@end
