//
//  RACCommand+MBProgressHUD.h
//  Exchange
//
//  Created by Jave on 2018/1/18.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@class MBProgressHUD;
@interface RACCommand (MBProgressHUD)

// Default is NO.
@property (nonatomic, assign) BOOL enabled;

// Default is NO.
@property (nonatomic, assign) BOOL progressEnabled;

// Default is NO.
@property (nonatomic, assign) BOOL completeEnabled;

// Default is NO.
@property (nonatomic, assign) BOOL errorEnabled;

// Displauy success or failed image, Default is NO.
@property (nonatomic, assign) BOOL resultEnabled;

@property (nonatomic, assign) NSTimeInterval hideDuration;

@property (nonatomic, copy) NSString *progressText;
@property (nonatomic, copy) NSString *completedText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, copy) NSString * (^errorTextBlock)(NSError *error);

@property (nonatomic, weak) UIView *refrenceView;

@property (nonatomic, strong, readonly) MBProgressHUD *progressHUD;

@end
