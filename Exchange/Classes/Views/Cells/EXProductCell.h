//
//  EXProductCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXProductItemViewModel.h"

@interface EXProductCell : UITableViewCell <RACView>

@property (nonatomic, strong, readonly) EXProductItemViewModel *viewModel;

@end
