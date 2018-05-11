//
//  EXProductDetailTickerView.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXProductDetailTickerViewModel.h"

@interface EXProductDetailTickerView : UIView<RACView>

@property (nonatomic, strong, readonly) EXProductDetailTickerViewModel *viewModel;

@end
