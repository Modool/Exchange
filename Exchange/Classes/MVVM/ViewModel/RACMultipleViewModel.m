//
//  RACMultipleViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACMultipleViewModel.h"
#import "RACTabBarController.h"

@interface  RACMultipleViewModel ()

@end

@implementation RACMultipleViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.viewControllerClass = [RACTabBarController class];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, currentViewModel) = [RACSignal combineLatest:@[RACObserve(self, currentIndex), RACObserve(self, viewModels)] reduce:^id(NSNumber *currentIndex, NSArray<RACControllerViewModel *> *viewModels){
        if (!viewModels.count || currentIndex.integerValue >= viewModels.count) return nil;
        return viewModels[currentIndex.integerValue];
    }];
}

@end
