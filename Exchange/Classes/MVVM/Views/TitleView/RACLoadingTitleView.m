//
//  RACLoadingTitleView.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACLoadingTitleView.h"

@interface RACLoadingTitleView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, copy) NSString *loadingText;

@end

@implementation RACLoadingTitleView

+ (instancetype)titleViewWithLoadingText:(NSString *)loadingText{
    return [[self alloc] initWithLoadingText:loadingText];
}

- (instancetype)initWithLoadingText:(NSString *)loadingText{
    if (self = [super initWithFrame:CGRectZero]) {
        self.loadingText = loadingText;
        
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self addSubview:[self activityIndicatorView]];
    [self addSubview:[self loadingLabel]];
    @weakify(self);
    RACSignal *loadingLabelSignal = [RACObserve([self loadingLabel], text) doNext:^(id x) {
        @strongify(self);
        [[self loadingLabel] sizeToFit];
    }];
    RACSignal *activityIndicatorViewSignal = [RACObserve([self activityIndicatorView], activityIndicatorViewStyle) doNext:^(id x) {
        @strongify(self);
        [[self activityIndicatorView] sizeToFit];
    }];
    [[RACSignal combineLatest:@[ loadingLabelSignal, activityIndicatorViewSignal ]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.frame = CGRectMake(0, 0, CGRectGetWidth([[self loadingLabel] frame]) + CGRectGetWidth([[self activityIndicatorView] frame]) + 4, 44);
    }];
    self.loadingLabel.text = [self loadingText] ?: @"加载中...";
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateSubviewsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubviewsLayout];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [[self activityIndicatorView] startAnimating];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [[self activityIndicatorView] stopAnimating];
    }
}

- (void)updateSubviewsLayout{
    CGRect activityIndicatorViewFrame = [[self activityIndicatorView] frame];
    activityIndicatorViewFrame.origin.y = CGRectGetHeight([self frame]) / 2 - CGRectGetHeight([[self activityIndicatorView] frame]) / 2;
    activityIndicatorViewFrame.origin.x = 0;
    self.activityIndicatorView.frame = activityIndicatorViewFrame;
    CGRect loadingLabelFrame = [[self loadingLabel] frame];
    loadingLabelFrame.size.width = MIN(CGRectGetWidth([[self loadingLabel] frame]), CGRectGetWidth([self frame]) - CGRectGetWidth(activityIndicatorViewFrame) - 4);
    loadingLabelFrame.origin.x = CGRectGetWidth(activityIndicatorViewFrame) + 4;
    loadingLabelFrame.origin.y = CGRectGetHeight([self frame]) / 2 - CGRectGetHeight(loadingLabelFrame) / 2;
    [self loadingLabel].frame = loadingLabelFrame;
}

- (UIActivityIndicatorView *) activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicatorView;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel = [UILabel new];
        _loadingLabel.font = [UIFont boldSystemFontOfSize:17];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.textColor = UIColor.whiteColor;
    }
    return _loadingLabel;
}

@end
