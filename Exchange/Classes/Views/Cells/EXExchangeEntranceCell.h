//
//  EXExchangeEntranceCell.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSwitchTableViewCell.h"
#import "EXExchangeEntranceItemViewModel.h"

@interface EXExchangeEntranceCell : UITableViewCell<RACView>

@property (nonatomic, strong, readonly) EXExchangeEntranceItemViewModel *viewModel;

@end
