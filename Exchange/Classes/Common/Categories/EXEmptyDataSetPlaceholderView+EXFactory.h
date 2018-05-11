//
//  EXEmptyDataSetPlaceholderView+EXFactory.h
//  Exchange
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXEmptyDataSetPlaceholderView.h"

@interface EXEmptyDataSetPlaceholderView (EXFactory)

+ (instancetype)defaultPlaceholder;

+ (instancetype)defaultPlaceholderWithTitle:(NSString *)title;
+ (instancetype)defaultPlaceholderWithImage:(UIImage *)image title:(NSString *)title;

+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL;
+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL title:(NSString *)title;

@end
