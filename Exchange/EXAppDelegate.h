//
//  EXAppDelegate.h
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACNavigationControllerStack;
@interface EXAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) RACNavigationControllerStack *viewControllerStack;

@end

