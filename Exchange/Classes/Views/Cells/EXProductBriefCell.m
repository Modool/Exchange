//
//  EXProductBriefCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductBriefCell.h"

@interface EXProductBriefCell ()

@property (nonatomic, strong) CAShapeLayer *selectedLayer;

@end

@implementation EXProductBriefCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.selectedLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(5, 0)];
        [path addLineToPoint:CGPointMake(5, 5)];
        [path addLineToPoint:CGPointMake(0, 0)];
        
        self.selectedLayer.path = path.CGPath;
        
        [self.contentView.layer addSublayer:self.selectedLayer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectedLayer.frame = (CGRect){CGRectGetWidth(self.contentView.bounds) - 5, 0, 5, 5};
}

- (void)bindViewModel:(EXProductBriefItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.selectedLayer, hidden) = [[RACObserve(viewModel, collected) not] takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.textLabel, text) = [[RACSignal combineLatest:@[RACObserve(viewModel, from), RACObserve(viewModel, to)] reduce:^id(NSString *from, NSString *to){
        return fmts(@"%@/%@", from.uppercaseString, to.uppercaseString);
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end
