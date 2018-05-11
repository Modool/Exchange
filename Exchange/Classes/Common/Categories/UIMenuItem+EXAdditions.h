//
//  UIMenuItem+EXAdditions.h
//  Exchange
//
//  Created by 李小虎 on 2018/1/29.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMenuItem (EXAdditions)

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action command:(RACCommand *)command;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action userInfo:(id)userInfo command:(RACCommand *)command;

@end
