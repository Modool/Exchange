
//
//  EXProductViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/27.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductViewController.h"
#import "EXProductViewModel.h"
#import "RACTableSection.h"

@interface EXProductViewController ()

@property (nonatomic, strong, readonly) EXProductViewModel *viewModel;

@end

@implementation EXProductViewController
@dynamic viewModel;

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.requestDataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray<EXProduct *> *products) {
        @strongify(self);
        RACTableSection *section = self.viewModel.dataSource.firstObject ?: [[RACTableSection alloc] init];
        
        NSArray<EXProductBriefItemViewModel *> *viewModels = [self.viewModel viewModelsWithProducts:products];
        section.viewModels = [section.viewModels ?: @[] arrayByAddingObjectsFromArray:viewModels];
        self.viewModel.dataSource = (id)@[section];
        
        [[self tableView] reloadData];
    }];
}
    
@end
