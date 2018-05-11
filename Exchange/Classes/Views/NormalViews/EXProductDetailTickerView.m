//
//  EXProductDetailTickerView.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailTickerView.h"

@interface EXProductDetailTickerView ()

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *increasementLabel;

@property (nonatomic, strong) UILabel *volumeLabel;

@property (nonatomic, strong) UILabel *highestLabel;

@property (nonatomic, strong) UILabel *lowestLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation EXProductDetailTickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _installConstraints];
    }
    return self;
}

#pragma mark - private

- (void)_createSubviews{
    self.priceLabel = [[UILabel alloc] init];
    self.increasementLabel = [[UILabel alloc] init];
    self.volumeLabel = [[UILabel alloc] init];
    self.highestLabel = [[UILabel alloc] init];
    self.lowestLabel = [[UILabel alloc] init];
    self.bottomLineView = [[UIView alloc] init];
    
    [self addSubview:self.priceLabel];
    [self addSubview:self.increasementLabel];
    [self addSubview:self.volumeLabel];
    [self addSubview:self.highestLabel];
    [self addSubview:self.lowestLabel];
    [self addSubview:self.bottomLineView];
}

- (void)_initializeSubviews{
    self.bottomLineView.backgroundColor = [UIColor grayColor];
}

- (void)_installConstraints{
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.increasementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
    }];
    
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.increasementLabel.mas_bottom).offset(10);
    }];
    
    [self.highestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(30);
        make.centerY.equalTo(self.increasementLabel.mas_centerY);
    }];
    
    [self.lowestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(30);
        make.centerY.equalTo(self.volumeLabel.mas_centerY);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXProductDetailTickerViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.priceLabel, attributedText) = RACObserve(viewModel, priceAttributedString);
    RAC(self.increasementLabel, attributedText) = RACObserve(viewModel, increasementAttributedString);
    RAC(self.volumeLabel, attributedText) = RACObserve(viewModel, volumeAttributedString);
    RAC(self.highestLabel, attributedText) = RACObserve(viewModel, highestAttributedString);
    RAC(self.lowestLabel, attributedText) = RACObserve(viewModel, lowestAttributedString);
}

@end
