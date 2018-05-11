
//
//  EXProductCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductCell.h"

@interface EXProductCell ()

@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *legalRendePriceLabel;
@property (nonatomic, strong) UILabel *offsetLabel;
@property (nonatomic, strong) UILabel *increasementLabel;
@property (nonatomic, strong) UILabel *ratioLabel;

@property (nonatomic, strong) CAShapeLayer *selectedLayer;

@end

@implementation EXProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _installConstraints];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectedLayer.frame = (CGRect){CGRectGetWidth(self.contentView.bounds) - 5, 0, 5, 5};
}

#pragma mark - private

- (void)_createSubviews{
    self.symbolLabel = [[UILabel alloc] init];
    self.exchangeLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.legalRendePriceLabel = [[UILabel alloc] init];
    
    self.offsetLabel = [[UILabel alloc] init];
    self.increasementLabel = [[UILabel alloc] init];
    self.ratioLabel = [[UILabel alloc] init];
    self.selectedLayer = [CAShapeLayer layer];
    
    [self.contentView addSubview:self.symbolLabel];
    [self.contentView addSubview:self.exchangeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.legalRendePriceLabel];
    [self.contentView addSubview:self.offsetLabel];
    [self.contentView addSubview:self.increasementLabel];
    [self.contentView addSubview:self.ratioLabel];
    [self.contentView.layer addSublayer:self.selectedLayer];
}

- (void)_initializeSubviews{
    self.symbolLabel.font = [UIFont systemFontOfSize:14];
    self.symbolLabel.textColor = [UIColor blackColor];
    
    self.exchangeLabel.font = [UIFont systemFontOfSize:12];
    self.exchangeLabel.textColor = [UIColor lightGrayColor];

    self.priceLabel.font = [UIFont boldSystemFontOfSize:15];
    self.priceLabel.textColor = [UIColor blackColor];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    self.legalRendePriceLabel.font = [UIFont systemFontOfSize:13];
    self.legalRendePriceLabel.textColor = [UIColor grayColor];
    self.legalRendePriceLabel.textAlignment = NSTextAlignmentRight;
    
    self.offsetLabel.font = [UIFont systemFontOfSize:10];
    self.offsetLabel.textAlignment = NSTextAlignmentRight;
    
    self.increasementLabel.font = [UIFont systemFontOfSize:10];
    self.increasementLabel.textAlignment = NSTextAlignmentRight;
    
    self.ratioLabel.font = [UIFont systemFontOfSize:14];
    self.ratioLabel.textColor = [UIColor whiteColor];
    self.ratioLabel.textAlignment = NSTextAlignmentCenter;
    self.ratioLabel.layer.cornerRadius = 3;
    self.ratioLabel.layer.masksToBounds = YES;
    
    self.selectedLayer.fillColor = [[UIColor colorWithRed:0.19 green:0.56 blue:0.86 alpha:1.00] CGColor];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(5, 0)];
    [path addLineToPoint:CGPointMake(5, 5)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    self.selectedLayer.path = path.CGPath;
}

- (void)_installConstraints{
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ratioLabel.mas_left).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.legalRendePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ratioLabel.mas_left).offset(-20);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
    }];
    
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.offsetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ratioLabel);
        make.top.equalTo(self.ratioLabel.mas_bottom).offset(5);
    }];
    
    [self.increasementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ratioLabel);
        make.top.equalTo(self.offsetLabel.mas_bottom);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXProductItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.selectedLayer, hidden) = [[RACObserve(viewModel, collected) not] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.symbolLabel, attributedText) = [RACObserve(viewModel, symbolAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.exchangeLabel, attributedText) = [RACObserve(viewModel, exchangeAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceLabel, attributedText) = [RACObserve(viewModel, priceAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.legalRendePriceLabel, attributedText) = [RACObserve(viewModel, legalRendePriceAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.offsetLabel, attributedText) = [RACObserve(viewModel, offsetAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.increasementLabel, attributedText) = [RACObserve(viewModel, increasementAttributedString) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.ratioLabel, text) = [RACObserve(viewModel, increaseRatioString) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.ratioLabel, backgroundColor) = [RACObserve(viewModel, increaseRatioBackgroundColor) takeUntil:self.rac_prepareForReuseSignal];
}

@end
