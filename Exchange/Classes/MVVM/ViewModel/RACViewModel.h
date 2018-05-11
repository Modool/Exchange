//
//  RACViewModel.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACViewModel, RACSubject;
@protocol RACView <NSObject>

@property (nonatomic, strong, readonly) RACViewModel *viewModel;

- (void)bindViewModel:(RACViewModel *)viewModel;

@end

@interface RACViewModel : NSObject

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, strong, readonly) NSMutableDictionary *keyPathAndValues;

/// An additional method, in which you can initialize data, RACCommand etc.
- (void)initialize NS_REQUIRES_SUPER;

@end
