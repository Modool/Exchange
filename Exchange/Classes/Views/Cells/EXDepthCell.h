//
//  EXDepthCell.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDepthItemViewModel.h"

@interface EXDepthCell : UITableViewCell <RACView>

@property (nonatomic, strong, readonly) EXDepthItemViewModel *viewModel;

@end
