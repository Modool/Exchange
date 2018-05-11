//
//  EXBalanceCell.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/26.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXBalanceCell.h"

@implementation EXBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return self;
}

- (void)bindViewModel:(EXBalanceItemViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.textLabel, text) = [[RACObserve(viewModel, symbol) map:^id(NSString *value) {
        return [value uppercaseString];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.detailTextLabel, attributedText) = [[RACSignal combineLatest:@[RACObserve(viewModel, free), RACObserve(viewModel, freezed)] reduce:^id(NSNumber *free, NSNumber *freezed){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 8;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSString *prefix = [formatter stringFromNumber:free];
        if (freezed.doubleValue == 0) return [[NSAttributedString alloc] initWithString:prefix];
            
        NSString *sufix = [formatter stringFromNumber:freezed];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fmts(@"%@ / %@", prefix, sufix)];
        [attributedString addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(prefix.length + 3, sufix.length)];
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:NSMakeRange(prefix.length + 3, sufix.length)];
        
        return attributedString.copy;
    }] takeUntil:self.rac_prepareForReuseSignal];
}

@end
