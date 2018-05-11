//
//  EXEntranceCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXEntranceCell.h"

@implementation EXEntranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)bindViewModel:(EXEntranceItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.textLabel, text) = [RACObserve(viewModel, name) takeUntil:[self rac_prepareForReuseSignal]];
}

@end
