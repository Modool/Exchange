//
//  UIViewController+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EXAdditions)

@end

@interface UIViewController (EXPresent)

- (void)presentViewController:(UIViewController *)viewController;
- (void)presentViewController:(UIViewController *)viewController animation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;
- (void)presentViewController:(UIViewController *)viewController defaultSet:(void (^)(UIView *view))defaultSet animation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;

@end

@interface UIViewController (EXDismiss)

- (void)dismissViewControllerCompletion:(void (^)(void))completion;
- (void)dismissViewControllerAnimation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;

@end

@interface UIViewController (EXVisibleViewController)

@property(strong, nonatomic, readonly) UINavigationController* topNavigationController;
@property(strong, nonatomic, readonly) UIViewController* topVisibleViewController;

@property(strong, nonatomic, readonly, class) UINavigationController* topNavigationController;
@property(strong, nonatomic, readonly, class) UIViewController* topVisibleViewController;

@end
