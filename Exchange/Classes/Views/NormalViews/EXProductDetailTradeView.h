//
//  EXProductDetailTradeView.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXProductDetailTradeViewModel.h"

@interface EXProductDetailTradeView : UIView<RACView>

@property (nonatomic, strong, readonly) EXProductDetailTradeViewModel *viewModel;

@end
