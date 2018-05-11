//
//  MBProgressHUD+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "MBProgressHUD+EXAdditions.h"
#import "EXUtils.h"
#import "EXMacros.h"
#import "EXTransformMacros.h"

const NSTimeInterval MBProgressHUDDefaultDuration = 1.5f;

@interface MBProgressHUDImageView : UIImageView
@end

@implementation MBProgressHUDImageView

- (CGSize)intrinsicContentSize{
    return CGSizeMake(17, 17);
}

@end

@implementation MBProgressHUD (EXAdditions)
@dynamic indicator;

+ (instancetype)HUDAddedTo:(UIView *)view {
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    
    hud.userInteractionEnabled = NO;
    
    hud.margin = 7.f;
    hud.minSize = CGSizeMake(147.f, 64.f);
    
    hud.removeFromSuperViewOnHide = YES;
    hud.defaultMotionEffectsEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    
    hud.label.textColor = [UIColor blackColor];
    hud.label.font = [UIFont boldSystemFontOfSize:12];
    
    hud.detailsLabel.textColor = [UIColor blackColor];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:12];
    
    hud.bezelView.color = [UIColor colorWithWhite:.99f alpha:1.f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    [view addSubview:hud];
    
    return hud;
}


+ (instancetype)textHUDAddedTo:(UIView *)view{
    MBProgressHUD *hud = [self HUDAddedTo:view];
    
    hud.margin = 7.f;
    hud.minSize = CGSizeMake(100.f, 40.f);
    
    hud.mode = MBProgressHUDModeText;
    
    hud.label.font = [UIFont systemFontOfSize:16];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    
    [view addSubview:hud];
    
    return hud;
}

- (void)hideHUDImmediately;{
    [self hideHUDImmediatelyAnimated:YES];
}

- (void)hideHUDImmediatelyAnimated:(BOOL)animated;{
    [self hideHUDAnimated:animated afterDelay:0];
}

- (void)hideHUDAnimated:(BOOL)animated;{
    [self hideHUDAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)hideHUDAnimated:(BOOL)animated afterDelay:(CGFloat)delay {
    self.animationType = MBProgressHUDAnimationZoomOut;
    
    [self hideAnimated:animated afterDelay:delay];
}

+ (MBProgressHUD *)showProgressInView:(UIView *)view;{
    return [self showProgressText:nil inView:view];
}

+ (MBProgressHUD *)showProgressText:(NSString *)text inView:(UIView *)view;{
    return [self showProgressText:text inView:view animated:YES];
}

+ (MBProgressHUD *)showProgressText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;{
    [self hideHUDForView:view animated:NO];
    
    MBProgressHUD *hud = [self HUDAddedTo:view];
    hud.label.text = text;
    
    ((UIActivityIndicatorView *)[hud indicator]).color = [UIColor colorWithRed:40/255.0 green:173/255.0 blue:228/255.0 alpha:1];
    
    [hud showAnimated:animated];
    
    return hud;
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view;{
    return [self showText:text inView:view animated:YES];
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;{
    return [self showText:text inView:view animated:animated afterDelay:MBProgressHUDDefaultDuration];
}

+ (MBProgressHUD *)showText:(NSString *)text inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    return [self showImage:nil text:text inView:view animated:animated afterDelay:delay];
}

+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view;{
    return [self showImage:image inView:view animated:YES];
}

+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view animated:(BOOL)animated;{
    return [self showImage:image inView:view animated:animated afterDelay:MBProgressHUDDefaultDuration];
}

+ (MBProgressHUD *)showImage:(UIImage *)image inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    return [self showImage:image text:nil inView:view animated:animated afterDelay:delay];;
}

+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view;{
    return [self showImage:image text:text inView:view animated:YES];
}

+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view animated:(BOOL)animated;{
    return [self showImage:image text:text inView:view animated:animated afterDelay:MBProgressHUDDefaultDuration];
}

+ (MBProgressHUD *)showImage:(UIImage *)image text:(NSString *)text inView:(UIView *)view animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    [self hideHUDForView:view animated:NO];
    
    MBProgressHUD *hud = SELECT(image != nil, [self HUDAddedTo:view], [self textHUDAddedTo:view]);
    hud.mode = SELECT(image != nil, MBProgressHUDModeCustomView, MBProgressHUDModeText);
    
    hud.label.text = text;
    hud.customView = SELECT(image != nil, [[MBProgressHUDImageView alloc] initWithImage:image], nil);
    
    [hud showAnimated:animated];
    [hud hideHUDAnimated:animated afterDelay:delay];

    return hud;
}

- (void)toText:(NSString *)text;{
    [self toText:text hideAnimated:YES];
}

- (void)toText:(NSString *)text hideAnimated:(BOOL)animated;{
    [self toText:text hideAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)toText:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    self.mode = MBProgressHUDModeText;
    self.label.text = text;
    
    [self hideHUDAnimated:animated afterDelay:delay];
}

- (void)toImage:(UIImage *)image;{
    [self toImage:image hideAnimated:YES];
}

- (void)toImage:(UIImage *)image hideAnimated:(BOOL)animated;{
    [self toImage:image hideAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)toImage:(UIImage *)image hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[MBProgressHUDImageView alloc] initWithImage:image];
    
    [self hideHUDAnimated:animated afterDelay:delay];
}

- (void)toImage:(UIImage *)image text:(NSString *)text;{
    [self toImage:image text:text hideAnimated:YES];
}

- (void)toImage:(UIImage *)image text:(NSString *)text hideAnimated:(BOOL)animated;{
    [self toImage:image text:text hideAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)toImage:(UIImage *)image text:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    self.mode = MBProgressHUDModeCustomView;
    
    self.label.text = text;
    self.customView = [[MBProgressHUDImageView alloc] initWithImage:image];
    
    [self hideHUDAnimated:animated afterDelay:delay];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success;{
    return [self showInView:view success:success animated:YES];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success animated:(BOOL)animated;{
    return [self showInView:view success:success animated:animated afterDelay:MBProgressHUDDefaultDuration];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    
    return [self showInView:view success:success text:nil animated:animated afterDelay:delay];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text;{
    return [self showInView:view success:success text:text animated:YES];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text animated:(BOOL)animated;{
    return [self showInView:view success:success text:text animated:animated afterDelay:MBProgressHUDDefaultDuration];
}

+ (MBProgressHUD *)showInView:(UIView *)view success:(BOOL)success text:(NSString *)text animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    UIImage *image = SELECT(success, EXImageNamed(@"blink_img_progress_hud_success_n"), EXImageNamed(@"blink_img_progress_hud_failed_n"));
    
    return [self showImage:image text:text inView:view animated:animated];
}

- (void)success;{
    [self success:YES];
}

- (void)failure;{
    [self success:NO];
}

- (void)success:(BOOL)success{
    [self success:success hideAnimated:YES];
}

- (void)success:(BOOL)success hideAnimated:(BOOL)animated{
    [self success:success hideAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)success:(BOOL)success hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    [self success:success text:nil hideAnimated:animated afterDelay:delay];
}

- (void)successWithText:(NSString *)text;{
    [self success:YES text:text];
}

- (void)failureWithText:(NSString *)text;{
    [self success:NO text:text];
}

- (void)success:(BOOL)success text:(NSString *)text;{
    [self success:success text:text hideAnimated:YES];
}

- (void)success:(BOOL)success text:(NSString *)text hideAnimated:(BOOL)animated;{
    [self success:success text:text hideAnimated:animated afterDelay:MBProgressHUDDefaultDuration];
}

- (void)success:(BOOL)success text:(NSString *)text hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;{
    UIImage *image = SELECT(success, EXImageNamed(@"blink_img_progress_hud_success_n"), EXImageNamed(@"blink_img_progress_hud_failed_n"));
    
    [self toImage:image text:text hideAnimated:animated afterDelay:delay];
}

@end
