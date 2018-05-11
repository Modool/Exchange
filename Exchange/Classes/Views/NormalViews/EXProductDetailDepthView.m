//
//  EXProductDetailDepthView.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailDepthView.h"

@interface EXProductDetailDepthView ()
@end

@implementation EXProductDetailDepthView

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
}

- (void)_initializeSubviews{
}

- (void)_installConstraints{
    
}

#pragma mark - public

- (void)bindViewModel:(EXProductDetailDepthViewModel *)viewModel{
    _viewModel = viewModel;
    
}

@end
