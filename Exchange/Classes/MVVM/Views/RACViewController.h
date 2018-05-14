//
//  RACViewController.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXMacros.h"
#import "RACControllerViewModel.h"

@interface RACViewController : UIViewController<RACViewController>

@property (nonatomic, assign, readonly) UIEdgeInsets safeAreaInsets;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil EX_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder EX_UNAVAILABLE;

- (instancetype)initWithViewModel:(RACControllerViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

@end
