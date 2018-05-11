//
//  RACControllerViewModel.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACControllerViewModel.h"

@interface RACControllerViewModel ()

@property (nonatomic, strong) id<RACViewModelServices> services;

@property (nonatomic, strong) RACSubject *didLoadViewSignal;

@property (nonatomic, strong) RACSubject *willAppearSignal;
@property (nonatomic, strong) RACSubject *didAppearSignal;

@property (nonatomic, strong) RACSubject *willDisappearSignal;
@property (nonatomic, strong) RACSubject *didDisappearSignal;

@end

@implementation RACControllerViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    RACControllerViewModel *viewModel = [super allocWithZone:zone];
    @weakify(viewModel);
    [[viewModel rac_signalForSelector:@selector(initWithServices:params:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    
    return viewModel;
}

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params;{
    if (self = [super init]) {
        self.services = services;
    }
    return self;
}

- (void)initialize;{
    [super initialize];
    
    RAC(self, viewLoaded) = [[self didLoadViewSignal] mapReplace:@YES];
    RAC(self, appeared) = [RACSignal merge:@[[[self didAppearSignal] mapReplace:@YES], [[self didDisappearSignal] mapReplace:@NO]]];
}

#pragma mark - accessor

- (UITabBarItem *)tabBarItem{
    if (!_tabBarItem) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:[self title] image:nil selectedImage:nil];
    }
    return _tabBarItem;
}

- (RACSubject *)didLoadViewSignal{
    if (!_didLoadViewSignal) _didLoadViewSignal = [RACSubject subject];
    return _didLoadViewSignal;
}

- (RACSubject *)willAppearSignal{
    if (!_willAppearSignal) _willAppearSignal = [RACSubject subject];
    return _willAppearSignal;
}

- (RACSubject *)didAppearSignal{
    if (!_didAppearSignal) _didAppearSignal = [RACSubject subject];
    return _didAppearSignal;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

- (RACSubject *)didDisappearSignal{
    if (!_didDisappearSignal) _didDisappearSignal = [RACSubject subject];
    return _didDisappearSignal;
}


@end
