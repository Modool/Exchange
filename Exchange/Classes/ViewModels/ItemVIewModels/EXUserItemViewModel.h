//
//  EXUserItemViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACTableSection.h"

@class EXExchange;
@protocol EXUserItemViewModel <RACTableRow>

@property (nonatomic, strong, readonly) EXExchange *exchange;

@optional
@property (nonatomic, assign, readonly) CGFloat height;

- (CGFloat)heightInContentView:(UIView *)contentView;

@end
