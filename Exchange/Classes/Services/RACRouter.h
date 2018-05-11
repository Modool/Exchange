//
//  RACRouter.h
//  MarkeJave
//
//  Created by Marke Jave on 14/12/27.
//  Copyright (c) 2018年 MarkeJave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+RACViewController.h"
#import "RACControllerViewModel.h"

@interface RACRouter : NSObject

/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (UIViewController *)viewControllerForViewModel:(RACControllerViewModel *)viewModel;

@end
