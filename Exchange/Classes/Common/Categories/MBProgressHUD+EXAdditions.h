//
//  MBProgressHUD+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

UIKIT_EXTERN const NSTimeInterval MBProgressHUDDefaultDuration;

@interface MBProgressHUD (EXAdditions)

@property (nonatomic, strong, readonly) UIView *indicator;

+ (MBProgressHUD *)showProgressInView:(UIView *)view;
+ (MBProgressHUD *)showProgressText:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)showProgressText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;
+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view;
+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view animated:(BOOL)animated;
+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view;
+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;
+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)toText:(NSString *)text;
- (void)toText:(NSString *)text hideAnimated:(BOOL)animated;
- (void)toText:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)toImage:(UIImage *)image;
- (void)toImage:(UIImage *)image hideAnimated:(BOOL)animated;
- (void)toImage:(UIImage *)image hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)toImage:(UIImage *)image text:(NSString *)text;
- (void)toImage:(UIImage *)image text:(NSString *)text hideAnimated:(BOOL)animated;
- (void)toImage:(UIImage *)image text:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success;
+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success animated:(BOOL)animated;
+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text;
+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text animated:(BOOL)animated;
+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)success;
- (void)failure;
- (void)success:(BOOL)success;
- (void)success:(BOOL)success hideAnimated:(BOOL)animated;
- (void)success:(BOOL)success hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)successWithText:(NSString *)text;
- (void)failureWithText:(NSString *)text;
- (void)success:(BOOL)success text:(NSString *)text;
- (void)success:(BOOL)success text:(NSString *)text hideAnimated:(BOOL)animated;
- (void)success:(BOOL)success text:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

- (void)hideHUDImmediately;
- (void)hideHUDImmediatelyAnimated:(BOOL)animated;

- (void)hideHUDAnimated:(BOOL)animated;
- (void)hideHUDAnimated:(BOOL)animated afterDelay:(CGFloat)delay;

@end
