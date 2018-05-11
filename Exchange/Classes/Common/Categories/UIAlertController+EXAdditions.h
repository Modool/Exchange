//
//  UIAlertController+EXAdditions.h
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACCommand;
@interface UIAlertController (EXAdditions)

+ (instancetype)alertNamed:(NSString *)title;
+ (instancetype)alertNamed:(NSString *)title message:(NSString *)message;

+ (instancetype)actionSheetNamed:(NSString *)title;
+ (instancetype)actionSheetNamed:(NSString *)title message:(NSString *)message;

- (instancetype)actionNamed:(NSString *)title;
- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style;

- (instancetype)actionNamed:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;
- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler;

- (instancetype)actionNamed:(NSString *)title command:(RACCommand *)command;
- (instancetype)actionNamed:(NSString *)title style:(UIAlertActionStyle)style command:(RACCommand *)command;

@end

@interface UIAlertAction (EXAdditions)

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style;

@end

@interface UIAlertAction (RACCommand)

@property (nonatomic, strong) RACCommand *rac_command;

+ (instancetype)rac_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style;
+ (instancetype)rac_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style command:(RACCommand *)command;

@end

