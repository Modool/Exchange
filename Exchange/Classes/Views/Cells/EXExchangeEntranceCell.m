//
//  EXExchangeEntranceCell.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeEntranceCell.h"

@interface EXExchangeEntranceCell ()

@property (nonatomic, strong) EXExchangeEntranceItemViewModel *viewModel;

@property (nonatomic, strong) UILabel *ratelabel;

@end

@implementation EXExchangeEntranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.ratelabel = [[UILabel alloc] init];
        self.ratelabel.textColor = [UIColor blueColor];
        self.ratelabel.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:self.ratelabel];
        [[self ratelabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)bindViewModel:(EXExchangeEntranceItemViewModel *)viewModel{
    self.viewModel = viewModel;
    
    RAC([self textLabel], text) = [RACObserve(viewModel, name) takeUntil:[self rac_prepareForReuseSignal]];
    RAC([self detailTextLabel], text) = [RACObserve(viewModel, APIKey) takeUntil:[self rac_prepareForReuseSignal]];
    RAC([self ratelabel], text) = [RACObserve(viewModel, rateDescription) takeUntil:[self rac_prepareForReuseSignal]];
}

@end
