//
//  RACControllerProtocol.h
//  ThaiynMall
//
//  Created by Marke Jave on 16/5/3.
//  Copyright © 2018年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXMacros.h"

@class RACControllerViewModel;
@protocol RACControllerProtocol <NSObject>

/// Present the corresponding view controller.
///
/// viewModel  - the view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)presentViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated completion:(EXVoidBlock)completion;

/// Present the corresponding view controller with auto-create navigation controller.
///
/// viewModel  - the view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)presentNavigationWithRootViewModel:(RACControllerViewModel *)viewModel animated:(BOOL)animated completion:(EXVoidBlock)completion;

/// Dismiss the presented view controller.
///
/// animated   - use animation or not
/// completion - the completion handler
- (void)dismissViewModelAnimated:(BOOL)animated completion:(EXVoidBlock)completion;

@end
