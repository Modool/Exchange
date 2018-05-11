//
//  EXEntranceCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXEntranceItemViewModel.h"

@interface EXEntranceCell : UITableViewCell<RACView>

@property (nonatomic, strong, readonly) EXEntranceItemViewModel *viewModel;

@end
