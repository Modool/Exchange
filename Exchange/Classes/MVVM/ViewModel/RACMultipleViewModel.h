//
//  RACMultipleViewModel.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACControllerViewModel.h"

@interface RACMultipleViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) RACControllerViewModel *currentViewModel;

@property (nonatomic, copy) NSArray<RACControllerViewModel *> *viewModels;

@property (nonatomic, assign) NSUInteger currentIndex;

@end
