//
//  RACNavigationProtocol.h
//  MarkeJave
//
//  Created by Marke Jave on 15/1/10.
//  Copyright (c) 2018年 Marke Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACControllerProtocol.h"

@protocol RACNavigationProtocol <RACControllerProtocol>

/// Pushes the corresponding view controller.
///
/// Uses a horizontal slide transition.
/// Has no effect if the corresponding view controller is already in the stack.
///
/// viewModel - the view model
/// animated  - use animation or not
- (void)pushViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated;

/// Pops the top view controller in the stack.
///
/// animated - use animation or not
- (void)popViewModelAnimated:(BOOL)animated;

/// Pops until there's only a single view controller left on the stack.
///
/// animated - use animation or not
- (void)popToRootViewModelAnimated:(BOOL)animated;

/// Reset the corresponding view controller as the root view controller of the application's window.
///
/// viewModel - the view model
- (void)resetRootViewModel:(RACControllerViewModel *)viewModel;
- (void)resetRootNavigationWithViewModel:(RACControllerViewModel *)viewModel;

@end
