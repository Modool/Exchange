//
//  UIViewController+MDTransitioning.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>
#import "UIViewController+MDTransitioning.h"

@implementation UIViewController (MDTransitioning)

- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;{
    MDScaleNavigationAnimationController *animation = [[MDScaleNavigationAnimationController alloc] initWithNavigationControllerOperation:operation fromViewController:fromViewController toViewController:toViewController];
//    animation.snapshotEnable = NO;
    
    return animation;
}

@end
