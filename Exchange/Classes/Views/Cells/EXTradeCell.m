//
//  EXTradeCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXTradeCell.h"

@interface EXTradeCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation EXTradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _installConstraints];
    }
    return self;
}

- (void)_createSubviews{
    self.timeLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.amountLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.amountLabel];
}

- (void)_initializeSubviews{
    self.priceLabel.font = [UIFont systemFontOfSize:13];

    self.timeLabel.textColor = UIColor.grayColor;
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    
    self.amountLabel.textColor = UIColor.grayColor;
    self.amountLabel.font = [UIFont systemFontOfSize:13];
}

- (void)_installConstraints{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(-50);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXTradeItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    self.timeLabel.text = viewModel.timeString;
    self.priceLabel.text = [NSString stringFromDoubleValue:viewModel.price];
    self.amountLabel.text = [NSString stringFromDoubleValue:viewModel.amount];
    
    UIColor *textColor = viewModel.buy ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00];
    self.priceLabel.textColor = textColor;
}

@end
