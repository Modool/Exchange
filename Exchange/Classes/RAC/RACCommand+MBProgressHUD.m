
//
//  RACCommand+MBProgressHUD.m
//  Exchange
//
//  Created by Jave on 2018/1/18.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <objc/runtime.h>
#import "RACCommand+MBProgressHUD.h"
#import "MBProgressHUD+EXAdditions.h"

@interface RACCommand (MBProgressHUDPrivate)

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation RACCommand (MBProgressHUDPrivate)
@dynamic progressHUD;
@end

@implementation RACCommand (MBProgressHUD)

+ (instancetype)allocWithZone:(NSZone *)zone{
    RACCommand *command = [super allocWithZone:zone];
    
    @weakify(command);
    [[command rac_signalForSelector:@selector(initWithEnabled:signalBlock:)] subscribeNext:^(id x) {
        @strongify(command);
        [command _bindSignals];
    }];
    return command;
}

#pragma mark - accessor

- (void)setEnabled:(BOOL)HUDEnabled{
    self.progressEnabled = YES;
    self.completeEnabled = YES;
    self.errorEnabled = YES;
}

- (BOOL)enabled{
    return NO;
}

- (BOOL)progressEnabled {
    return [objc_getAssociatedObject(self, @selector(progressEnabled)) boolValue];
}

- (void)setProgressEnabled:(BOOL)HUDProgressEnabled{
    [self willChangeValueForKey:NSStringFromSelector(@selector(progressEnabled))];
    objc_setAssociatedObject(self, @selector(progressEnabled), @(HUDProgressEnabled), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(progressEnabled))];
}

- (BOOL)completeEnabled{
    return [objc_getAssociatedObject(self, @selector(completeEnabled)) boolValue];
}

- (void)setCompleteEnabled:(BOOL)completeEnabled{
    [self willChangeValueForKey:NSStringFromSelector(@selector(completeEnabled))];
    objc_setAssociatedObject(self, @selector(completeEnabled), @(completeEnabled), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(completeEnabled))];
    
    if (!completeEnabled) self.errorEnabled = NO;
}

- (BOOL)errorEnabled{
    return [objc_getAssociatedObject(self, @selector(errorEnabled)) boolValue];
}

- (void)setErrorEnabled:(BOOL)errorEnabled{
    [self willChangeValueForKey:NSStringFromSelector(@selector(errorEnabled))];
    objc_setAssociatedObject(self, @selector(errorEnabled), @(errorEnabled), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(errorEnabled))];
}

- (BOOL)resultEnabled{
    return [objc_getAssociatedObject(self, @selector(resultEnabled)) boolValue];
}

- (void)setResultEnabled:(BOOL)resultEnabled{
    [self willChangeValueForKey:NSStringFromSelector(@selector(resultEnabled))];
    objc_setAssociatedObject(self, @selector(resultEnabled), @(resultEnabled), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(resultEnabled))];
}

- (NSTimeInterval)hideDuration{
    return [objc_getAssociatedObject(self, @selector(hideDuration)) doubleValue];
}

- (void)setHideDuration:(NSTimeInterval)hideDuration{
    [self willChangeValueForKey:NSStringFromSelector(@selector(hideDuration))];
    objc_setAssociatedObject(self, @selector(hideDuration), @(hideDuration), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(@selector(hideDuration))];
}

- (NSString *)progressText{
    return objc_getAssociatedObject(self, @selector(progressText));
}

- (void)setProgressText:(NSString *)progressText{
    [self willChangeValueForKey:NSStringFromSelector(@selector(progressText))];
    objc_setAssociatedObject(self, @selector(progressText), progressText, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(progressText))];
}

- (NSString *)completedText{
    return objc_getAssociatedObject(self, @selector(completedText));
}

- (void)setCompletedText:(NSString *)completedText{
    [self willChangeValueForKey:NSStringFromSelector(@selector(completedText))];
    objc_setAssociatedObject(self, @selector(completedText), completedText, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(completedText))];
}

- (NSString *)errorText{
    return objc_getAssociatedObject(self, @selector(errorText));
}

- (void)setErrorText:(NSString *)errorText{
    [self willChangeValueForKey:NSStringFromSelector(@selector(errorText))];
    objc_setAssociatedObject(self, @selector(errorText), errorText, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:NSStringFromSelector(@selector(errorText))];
}

- (NSString *(^)(NSError *))errorTextBlock{
    return objc_getAssociatedObject(self, @selector(errorTextBlock));
}

- (void)setErrorTextBlock:(NSString *(^)(NSError *))errorTextBlock{
    objc_setAssociatedObject(self, @selector(errorTextBlock), errorTextBlock, OBJC_ASSOCIATION_COPY);
}

- (UIView *)refrenceView{
    return objc_getAssociatedObject(self, @selector(refrenceView));
}

- (void)setRefrenceView:(UIView *)refrenceView{
    objc_setAssociatedObject(self, @selector(refrenceView), refrenceView, OBJC_ASSOCIATION_ASSIGN);
}

- (MBProgressHUD *)progressHUD{
    return objc_getAssociatedObject(self, @selector(progressHUD));
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD{
    objc_setAssociatedObject(self, @selector(progressHUD), progressHUD, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - private

- (void)_bindSignals{
#define progressHUD   self.progressHUD
    
    @weakify(self);
    [[[[[self executing] filter:^BOOL(id excuting) {
        @strongify(self);
        return [self progressEnabled];
    }] map:^id(id excuting) {
        @strongify(self);
        return RACTuplePack(excuting, @([self completeEnabled]), [self progressText], [self refrenceView] ?: [[UIApplication sharedApplication] keyWindow]);
    }] deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *excuting, NSNumber *completeEnabled, NSString *progressText, UIView *refrenceView) = tuple;
        if ([excuting boolValue]) {
            progressHUD = [MBProgressHUD showProgressText:progressText inView:refrenceView];
        } else if (![completeEnabled boolValue]) {
            [progressHUD hideAnimated:YES];
        }
    }];
    
    [[[[[[self executionSignals] switchToLatest] deliverOnMainThread] filter:^BOOL(id value) {
        @strongify(self);
        return [self completeEnabled];
    }] map:^id(id value) {
        @strongify(self);
        return RACTuplePack(@([self resultEnabled]), [self completedText], [self refrenceView] ?: [[UIApplication sharedApplication] keyWindow]);
    }] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *resultEnabled, NSString *completedText, UIView *refrenceView) = tuple;
        if (progressHUD && ![completedText length]) {
            [progressHUD hideAnimated:YES];
        } else if (progressHUD && [completedText length]) {
            if ([resultEnabled boolValue]) [progressHUD toText:completedText];
            else [progressHUD successWithText:completedText];
        } else if ([completedText length]){
            if ([resultEnabled boolValue]) [MBProgressHUD showInView:refrenceView success:YES text:completedText];
            else [MBProgressHUD showText:completedText inView:refrenceView];
        }
    }];
    
    [[[[self errors] filter:^BOOL(id value) {
        @strongify(self);
        return [self errorEnabled];
    }] map:^id(NSError *error) {
        @strongify(self);
        NSString *text = [self errorText] ?: ([self errorTextBlock] ? self.errorTextBlock(error) : [error localizedDescription]);
        return RACTuplePack(@([self resultEnabled]), text, [self refrenceView] ?: [[UIApplication sharedApplication] keyWindow]);
    }] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *resultEnabled, NSString *errorText, UIView *refrenceView) = tuple;
        if (progressHUD && ![errorText length]) {
            [progressHUD hideAnimated:YES];
        } else if (progressHUD && [errorText length]) {
            if ([resultEnabled boolValue]) [progressHUD toText:errorText];
            else [progressHUD failureWithText:errorText];
        } else if ([errorText length]){
            if ([resultEnabled boolValue]) [MBProgressHUD showInView:refrenceView success:NO text:errorText];
            else [MBProgressHUD showText:errorText inView:refrenceView];
        }
    }];
}

@end
