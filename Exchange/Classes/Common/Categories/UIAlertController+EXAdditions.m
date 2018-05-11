//
//  UIAlertController+EXAdditions.m
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertController+EXAdditions.h"

@implementation UIAlertController (EXAdditions)

+ (instancetype)alertNamed:(NSString *)title;{
    return [self alertNamed:title message:nil];
}

+ (instancetype)alertNamed:(NSString *)title message:(NSString *)message;{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

+ (instancetype)actionSheetNamed:(NSString *)title{
    return [self actionSheetNamed:title message:nil];
}

+ (instancetype)actionSheetNamed:(NSString *)title message:(NSString *)message;{
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}

- (instancetype)actionNamed:(NSString *)title;{
    return [self actionNamed:title style:UIAlertActionStyleDefault];
}

- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style;{
    return [self actionNamed:title style:style handler:nil];
}

- (instancetype)actionNamed:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;{
    return [self actionNamed:title style:UIAlertActionStyleDefault handler:handler];
}

- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler;{
    [self addAction:[UIAlertAction actionWithTitle:title style:style handler:handler]];
    
    return self;
}

- (instancetype)actionNamed:(NSString *)title command:(RACCommand *)command;{
    return [self actionNamed:title style:UIAlertActionStyleDefault command:command];
}

- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style command:(RACCommand *)command;{
    [self addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction *action) {
        [command execute:action];
    }]];
    
    return self;
}

@end

@implementation UIAlertAction (EXAdditions)

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style;{
    return [self actionWithTitle:title style:style handler:nil];
}

@end

@implementation UIAlertAction (RACCommand)

+ (instancetype)rac_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style;{
    return [self actionWithTitle:title style:style handler:^(UIAlertAction *action) {
        [[action rac_command] execute:action];
    }];
}

+ (instancetype)rac_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style command:(RACCommand *)command;{
    UIAlertAction *alertAction = [self rac_actionWithTitle:title style:style];
    alertAction.rac_command = command;
    
    return alertAction;
}

#pragma mark - accessor

- (void)setRac_command:(RACCommand *)rac_command{
    objc_setAssociatedObject(self, @selector(rac_command), rac_command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RACCommand *)rac_command{
    return objc_getAssociatedObject(self, @selector(rac_command));
}

@end
