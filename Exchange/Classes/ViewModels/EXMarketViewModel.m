//
//  EXMarketViewModel.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXMarketViewModel.h"
#import "EXMarketViewController.h"

#import "EXTransactionViewModel.h"
#import "EXCollectedTransactionViewModel.h"

#import "EXSearchProductViewModel.h"

@interface EXMarketViewModel ()

@property (nonatomic, strong) RACCommand *searchCommand;

@end

@implementation EXMarketViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"行情";
        self.viewControllerClass = EXClass(EXMarketViewController);
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[self title] image:EXImageNamed(@"img_trade_n") tag:0];
        
        EXCollectedTransactionViewModel *selectedViewModel = [[EXCollectedTransactionViewModel alloc] initWithServices:services params:nil];
        EXTransactionViewModel *normalViewModel = [[EXTransactionViewModel alloc] initWithServices:services params:nil];
        normalViewModel.title = @"所有";
        
        self.viewModels = @[selectedViewModel, normalViewModel];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        EXSearchProductViewModel *viewModel = [[EXSearchProductViewModel alloc] initWithServices:self.services params:nil];
        
        [[self services] pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
}

@end
