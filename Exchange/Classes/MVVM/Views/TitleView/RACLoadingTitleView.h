//
//  RACLoadingTitleView.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACLoadingTitleView : UIView

@property (nonatomic, copy, readonly) NSString *loadingText;

+ (instancetype)titleViewWithLoadingText:(NSString *)loadingText;
- (instancetype)initWithLoadingText:(NSString *)loadingText;

@end
