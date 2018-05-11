//
//  EXUnfinishedOrderCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXUnfinishedOrderCell.h"

@interface EXUnfinishedOrderCell ()

@property (nonatomic, strong) UILabel *symbolLabel;

@property (nonatomic, strong) UILabel *marketTypeLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *dealAmountLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation EXUnfinishedOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createSubview];
        [self _initializeSubview];
        [self _installSubview];
    }
    return self;
}

#pragma mark - private

- (void)_createSubview{
    self.symbolLabel = [[UILabel alloc] init];
    self.marketTypeLabel = [[UILabel alloc] init];
    self.typeLabel = [[UILabel alloc] init];
    self.amountLabel = [[UILabel alloc] init];
    self.dealAmountLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.timeLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.symbolLabel];
    [self.contentView addSubview:self.marketTypeLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.dealAmountLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)_initializeSubview{
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont boldSystemFontOfSize:15];
    self.typeLabel.layer.cornerRadius = 5;
    self.typeLabel.layer.masksToBounds = YES;
    
    self.marketTypeLabel.font = [UIFont boldSystemFontOfSize:14];
    self.marketTypeLabel.textColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.26 alpha:1.00];
    
    self.amountLabel.font = [UIFont systemFontOfSize:14];
    self.amountLabel.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.68 alpha:1.00];
    
    self.dealAmountLabel.font = [UIFont systemFontOfSize:14];
    self.dealAmountLabel.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.68 alpha:1.00];
    
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.68 alpha:1.00];
    
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1.00];
}

- (void)_installSubview{
    [self.marketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.marketTypeLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(20);
        make.centerY.equalTo(self.typeLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolLabel.mas_right).offset(20);
        make.centerY.equalTo(self.typeLabel);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.amountLabel);
    }];
    
    [self.dealAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(10);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXUnfinishedOrderItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.symbolLabel, text) = [[RACObserve(viewModel, from) mapPerformSelector:@selector(uppercaseString)] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.marketTypeLabel, text) = [[RACObserve(viewModel, type) map:^id(NSNumber *value) {
        return value.integerValue & EXTradeTypeMarket ? @"市价单" : @"限价单";
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.typeLabel, text) = [[RACObserve(viewModel, type) map:^id(NSNumber *value) {
        return value.integerValue & EXTradeTypeBuy ? @"买" : @"卖";
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.typeLabel, backgroundColor) = [[RACObserve(viewModel, type) map:^id(NSNumber *value) {
        return value.integerValue & EXTradeTypeBuy ? [UIColor colorWithRed:0.21 green:0.70 blue:0.31 alpha:1.00] : [UIColor colorWithRed:0.97 green:0.35 blue:0.37 alpha:1.00];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.amountLabel, text) = [[RACObserve(viewModel, amount) map:^id(NSNumber *value) {
        return fmts(@"委托量 %.8f", value.doubleValue);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.dealAmountLabel, text) = [[RACObserve(viewModel, dealAmount) map:^id(NSNumber *value) {
        return fmts(@"成交量 %.8f", value.doubleValue);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.priceLabel, text) = [[RACObserve(viewModel, price) map:^id(NSNumber *value) {
        return fmts(@"委托价 %.8f", value.doubleValue);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.timeLabel, text) = [[RACObserve(viewModel, time) map:^id(NSNumber *value) {
        return [[NSDate dateWithTimeIntervalSince1970:value.doubleValue] dateStringWithFormat:@"MM-dd"];
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end
