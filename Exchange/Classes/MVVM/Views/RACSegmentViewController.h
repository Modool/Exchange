//
//  RACSegmentViewController.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewController.h"

@class RACMultipleViewModel;
@interface RACSegmentViewController : RACViewController

@property (nonatomic, strong, readonly) RACMultipleViewModel *viewModel;

@end
