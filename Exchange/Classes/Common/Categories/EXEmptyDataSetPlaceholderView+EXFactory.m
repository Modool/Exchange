//
//  EXEmptyDataSetPlaceholderView+EXFactory.m
//  Exchange
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <FlyImage/FlyImage.h>
#import <CategoryKit/CategoryKit.h>
#import "EXEmptyDataSetPlaceholderView+EXFactory.h"

@implementation EXEmptyDataSetPlaceholderView (EXFactory)

+ (instancetype)defaultPlaceholder;{
    return [self defaultPlaceholderWithTitle:@"什么都木有┑(￣Д ￣)┍"];
}

+ (instancetype)defaultPlaceholderWithTitle:(NSString *)title;{
    return [self defaultPlaceholderWithImage:nil title:title];
}

+ (instancetype)defaultPlaceholderWithImage:(UIImage *)image title:(NSString *)title;{
    EXEmptyDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:image completion:nil];
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 20;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = UIColorWithHexRGB(0x999999);
    }];
    return placeholderView;
}

+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL;{
    return [self defaultPlaceholderWithImageURL:imageURL title:nil];
}

+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL title:(NSString *)title;{
    EXEmptyDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:nil completion:^(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width) {
        [imageView setImageURL:imageURL];
    }];
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 10;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorWithHexRGB(0x333333);
    }];
    return placeholderView;
}

@end
