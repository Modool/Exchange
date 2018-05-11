//
//  UIViewController+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "UIViewController+EXAdditions.h"

@implementation UIViewController (EXAdditions)

@end

@implementation UIViewController (EXPresent)

- (void)presentViewController:(UIViewController *)viewController;{
    [self presentViewController:viewController animation:nil completion:nil];
}

- (void)presentViewController:(UIViewController *)viewController animation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;{
    [self presentViewController:viewController defaultSet:nil animation:animation completion:completion];
}

- (void)presentViewController:(UIViewController *)viewController defaultSet:(void (^)(UIView *view))defaultSet animation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;{
    void (^willMoveInParentViewController)(void) = ^{
        [viewController willMoveToParentViewController:self];
    };
    void (^didMoveInParentViewController)(void) = ^{
        [viewController didMoveToParentViewController:self];
        if (completion) completion();
    };
    
    willMoveInParentViewController();
    
    [self addChildViewController:viewController];
    [[self view] addSubview:[viewController view]];
    
    if (defaultSet) defaultSet([viewController view]);
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            if (animation) animation([viewController view]);
        } completion:^(BOOL finished) {
            didMoveInParentViewController();
        }];
    } else {
        didMoveInParentViewController();
    }
}

@end

@implementation UIViewController (EXDismiss)

- (void)dismissViewControllerCompletion:(void (^)(void))completion;{
    [self dismissViewControllerAnimation:nil completion:completion];
}

- (void)dismissViewControllerAnimation:(void (^)(UIView *view))animation completion:(void (^)(void))completion;{
    void (^willMoveOutParentViewController)(void) = ^{
        [self willMoveToParentViewController:nil];
    };
    void (^didMoveOutParentViewController)(void) = ^{
        [[self view] removeFromSuperview];
        [self removeFromParentViewController];
        [self didMoveToParentViewController:nil];
        if (completion) completion();
    };
    
    willMoveOutParentViewController();
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            if (animation) animation([self view]);
        } completion:^(BOOL finished) {
            didMoveOutParentViewController();
        }];
    } else {
        didMoveOutParentViewController();
    }
}

@end

@implementation UIViewController (EXVisibleViewController)

- (UINavigationController *)topNavigationController{
    if ([self presentedViewController]) {
        return [[self presentedViewController] topNavigationController];
    }
    return nil;
}

- (UIViewController*)topVisibleViewController;{
    if ([self presentedViewController] && ![[self presentedViewController] isKindOfClass:[UIAlertController class]]) {
        return [[self presentedViewController] topVisibleViewController];
    }
    return self;
}

+ (UINavigationController *)topNavigationController{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    if ([rootViewController respondsToSelector:@selector(topNavigationController)]) {
        return [rootViewController performSelector:@selector(topNavigationController)];
    }
    return nil;
}

+ (UIViewController*)topVisibleViewController;{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    if ([rootViewController respondsToSelector:@selector(topVisibleViewController)]) {
        return [rootViewController performSelector:@selector(topVisibleViewController)];
    }
    return nil;
}

@end

@implementation UINavigationController (EXVisibleViewController)

- (UINavigationController*)topNavigationController;{
    if ([self presentedViewController]) {
        return [[self presentedViewController] topNavigationController] ?: self;
    }
    return [[self topViewController] topNavigationController] ?: self;
}

- (UIViewController*)topVisibleViewController;{
    if ([self presentedViewController] && ![[self presentedViewController] isKindOfClass:[UIAlertController class]]) {
        return [[self presentedViewController] topVisibleViewController];
    }
    return [[self topViewController] topVisibleViewController];
}

@end

@implementation UITabBarController (EXVisibleViewController)

- (UINavigationController*)topNavigationController;{
    if ([self presentedViewController]) {
        return [[self presentedViewController] topNavigationController];
    }
    return [[self selectedViewController] topNavigationController];
}

- (UIViewController*)topVisibleViewController;{
    if ([self presentedViewController] && ![[self presentedViewController] isKindOfClass:[UIAlertController class]]) {
        return [[self presentedViewController] topVisibleViewController];
    }
    return [[self selectedViewController] topVisibleViewController];
}

@end

@implementation UINavigationController (EXRotate)

#pragma mark - rotation accessor

- (BOOL)shouldAutorotate {
    return [[self topVisibleViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self topVisibleViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self topVisibleViewController] preferredInterfaceOrientationForPresentation];
}

@end

@implementation UINavigationController (EXStatusBar)

#pragma mark - status bar accessor

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topVisibleViewController] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return [[self topVisibleViewController] prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return [[self topVisibleViewController] preferredStatusBarUpdateAnimation];
}

@end

@implementation UITabBarController (EXRotate)

#pragma mark - rotation accessor

- (BOOL)shouldAutorotate {
    return [[self topVisibleViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self topVisibleViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self topVisibleViewController] preferredInterfaceOrientationForPresentation];
}

@end

@implementation UITabBarController (EXStatusBar)

#pragma mark - status bar accessor

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topVisibleViewController] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return [[self topVisibleViewController] prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return [[self topVisibleViewController] preferredStatusBarUpdateAnimation];
}

@end
