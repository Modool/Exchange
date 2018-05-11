//
//  EXProductDetailDepthView.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EXProductDetailDepthViewModel.h"

@interface EXProductDetailDepthView : UIView<RACView>

@property (nonatomic, strong, readonly) EXProductDetailDepthViewModel *viewModel;

@end
