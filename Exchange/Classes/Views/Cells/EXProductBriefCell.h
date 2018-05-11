//
//  EXProductBriefCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXProductBriefItemViewModel.h"

@interface EXProductBriefCell : UITableViewCell<RACView>

@property (nonatomic, strong, readonly) EXProductBriefItemViewModel *viewModel;

@end
