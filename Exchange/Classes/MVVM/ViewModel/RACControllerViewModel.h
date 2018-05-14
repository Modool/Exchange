//
//  RACControllerViewModel.h
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACViewModel.h"
#import "RACViewModelServices.h"

/// The type of the title view.
typedef NS_ENUM(NSUInteger, RACTitleViewType) {
    /// System title view
    RACTitleViewTypeDefault,
    /// Double title view
    RACTitleViewTypeDoubleTitle,
    /// Loading title view
    RACTitleViewTypeLoadingTitle
};

@class RACControllerViewModel;
@protocol RACViewController <NSObject>

/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) RACControllerViewModel *viewModel;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(RACControllerViewModel *)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end

@interface RACControllerViewModel : RACViewModel

@property (nonatomic, strong, readonly) id<RACViewModelServices> services;
@property (nonatomic, strong, readonly) NSDictionary *parameters;

@property (nonatomic, assign) RACTitleViewType titleViewType;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *subtitle;
@property (nonatomic, strong) UITabBarItem *tabBarItem;

/// The callback block.
@property (nonatomic, copy) void (^callback)(id object);

// RACViewController
@property (nonatomic, strong) Class viewControllerClass;

@property (nonatomic, assign, readonly, getter=isAppeared) BOOL appeared;
@property (nonatomic, assign, readonly, getter=isViewLoaded) BOOL viewLoaded;

@property (nonatomic, strong, readonly) RACSubject *didLoadViewSignal;

@property (nonatomic, strong, readonly) RACSubject *willAppearSignal;
@property (nonatomic, strong, readonly) RACSubject *didAppearSignal;
@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;
@property (nonatomic, strong, readonly) RACSubject *didDisappearSignal;

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params;

@end
