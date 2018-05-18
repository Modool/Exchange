//
//  EXDepthCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepthCell.h"

@interface EXDepthCell ()

@property (nonatomic, strong) UILabel *askPriceLabel;
@property (nonatomic, strong) UILabel *askVolumeLabel;

@property (nonatomic, strong) UILabel *bidPriceLabel;
@property (nonatomic, strong) UILabel *bidVolumeLabel;

@end

@implementation EXDepthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _installConstraints];
    }
    return self;
}

- (void)_createSubviews{
    self.askPriceLabel = [[UILabel alloc] init];
    self.askVolumeLabel = [[UILabel alloc] init];
    self.bidPriceLabel = [[UILabel alloc] init];
    self.bidVolumeLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.askPriceLabel];
    [self.contentView addSubview:self.askVolumeLabel];
    [self.contentView addSubview:self.bidPriceLabel];
    [self.contentView addSubview:self.bidVolumeLabel];
}

- (void)_initializeSubviews{
    self.askPriceLabel.font = [UIFont systemFontOfSize:13];
    self.askPriceLabel.textColor = [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00];
    
    self.askVolumeLabel.textColor = UIColor.grayColor;
    self.askVolumeLabel.font = [UIFont systemFontOfSize:13];
    
    self.bidPriceLabel.font = [UIFont systemFontOfSize:13];
    self.bidPriceLabel.textColor = [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00];
    
    self.bidVolumeLabel.textColor = UIColor.grayColor;
    self.bidVolumeLabel.font = [UIFont systemFontOfSize:13];
}

- (void)_installConstraints{
    [self.askVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.askPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bidPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bidVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXDepthItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    self.askPriceLabel.text = viewModel.askPrice > 0 ? fmts(@"%.8f", viewModel.askPrice) : nil;
    self.askVolumeLabel.text = viewModel.askVolume > 0 ? fmts(@"%.3f", viewModel.askVolume) : nil;

    self.bidPriceLabel.text = viewModel.bidPrice > 0 ? fmts(@"%.8f", viewModel.bidPrice) : nil;
    self.bidVolumeLabel.text = viewModel.bidVolume > 0 ? fmts(@"%.3f", viewModel.bidVolume) : nil;
}

@end
