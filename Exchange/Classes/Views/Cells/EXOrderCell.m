
//
//  EXOrderCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOrderCell.h"

@interface EXOrderCell ()

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *dealAmountLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *dealPriceLabel;

@property (nonatomic, strong) UILabel *averagePriceLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation EXOrderCell

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
    self.typeLabel = [[UILabel alloc] init];
    self.amountLabel = [[UILabel alloc] init];
    self.dealAmountLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.dealPriceLabel = [[UILabel alloc] init];
    self.averagePriceLabel = [[UILabel alloc] init];
    self.statusLabel = [[UILabel alloc] init];
    self.timeLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.dealAmountLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.dealPriceLabel];
    [self.contentView addSubview:self.averagePriceLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)_initializeSubview{
    self.typeLabel.font = [UIFont boldSystemFontOfSize:15];
    
    self.amountLabel.font = [UIFont systemFontOfSize:14];
    self.amountLabel.textColor = [UIColor colorWithRed:0.24 green:0.67 blue:0.98 alpha:1.00];
    
    self.dealAmountLabel.font = [UIFont systemFontOfSize:14];
    self.dealAmountLabel.textColor = [UIColor colorWithRed:0.24 green:0.67 blue:0.98 alpha:1.00];
    
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.66 alpha:1.00];
    
    self.averagePriceLabel.font = [UIFont systemFontOfSize:13];
    self.averagePriceLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.66 alpha:1.00];
    
    self.dealPriceLabel.font = [UIFont systemFontOfSize:13];
    self.dealPriceLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.66 alpha:1.00];
    
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.26 alpha:1.00];
    
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.26 alpha:1.00];
}

- (void)_installSubview{
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(15);
    }];
    
    [self.dealAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.amountLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(10);
    }];
    
    [self.averagePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
    }];
    
    [self.dealPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.averagePriceLabel.mas_bottom).offset(10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.dealPriceLabel.mas_bottom).offset(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.statusLabel);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXOrderItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.typeLabel, text) = [[RACObserve(viewModel, type) map:^id(NSNumber *value) {
        NSString *header = value.integerValue & EXTradeTypeMarket ? @"市价" : @"限价";
        NSString *footer = value.integerValue & EXTradeTypeBuy ? @"买入" : @"卖出";
        return [header stringByAppendingString:footer];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.typeLabel, textColor) = [[RACObserve(viewModel, type) map:^id(NSNumber *value) {
        return value.integerValue & EXTradeTypeBuy ? [UIColor colorWithRed:0.21 green:0.70 blue:0.31 alpha:1.00] : [UIColor colorWithRed:0.97 green:0.35 blue:0.37 alpha:1.00];
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.amountLabel, text) = [[RACObserve(viewModel, amount) map:^id(NSNumber *value) {
        return fmts(@"委托数量 %.4f %@", value.doubleValue, viewModel.name.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.dealAmountLabel, text) = [[RACObserve(viewModel, dealAmount) map:^id(NSNumber *value) {
        return fmts(@"成交数量 %.4f %@", value.doubleValue, viewModel.name.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.priceLabel, text) = [[RACObserve(viewModel, price) map:^id(NSNumber *value) {
        return fmts(@"委托价格 %.8f %@/%@", value.doubleValue, viewModel.name.uppercaseString, viewModel.name.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.averagePriceLabel, text) = [[RACObserve(viewModel, averagePrice) map:^id(NSNumber *value) {
        return fmts(@"成交均价 %.8f %@/%@", value.doubleValue, viewModel.name.uppercaseString, viewModel.name.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.dealPriceLabel, text) = [[RACObserve(viewModel, dealPrice) map:^id(NSNumber *value) {
        return fmts(@"成交均价 %.8f %@", value.doubleValue, viewModel.basic.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.statusLabel, text) = [[RACObserve(viewModel, status) map:^id(NSNumber *value) {
        return EXOrderStatusDescription(value.integerValue);
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.timeLabel, text) = [[RACObserve(viewModel, time) map:^id(NSNumber *value) {
        return [[NSDate dateWithTimeIntervalSince1970:value.doubleValue] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end
