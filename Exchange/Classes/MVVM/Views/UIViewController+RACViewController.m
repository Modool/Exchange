//
//  UIViewController+RACViewController.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "UIViewController+RACViewController.h"
#import "RACViewController.h"

@implementation UIViewController (RACViewController)

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    RACViewController *viewController = (id)[super allocWithZone:zone];
    @weakify(viewController);
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController);
        if ([viewController respondsToSelector:@selector(bindViewModel)]) {
            [viewController bindViewModel];
        };
    }];
    return viewController;
}

@end
