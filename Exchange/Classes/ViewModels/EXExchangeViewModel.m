//
//  EXExchangeViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeViewModel.h"
#import "EXExchangeViewController.h"

#import "EXQRCodeViewModel.h"

#import "EXExchange.h"

#import "EXExchangeManager.h"
#import "EXSocketManager.h"

NSString * const EXExchangeViewModelAPIKey = @"apiKey";
NSString * const EXExchangeViewModelSecretKey = @"secretKey";

@interface EXExchangeViewModel ()

@property (nonatomic, strong) RACCommand *saveCommand;
@property (nonatomic, strong) RACCommand *scanCommand;

@property (nonatomic, strong) RACCommand *loginCommand;

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *secretKey;

@property (nonatomic, assign) double CNYRate;

@end

@implementation EXExchangeViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        _exchange = params[@keypath(self, exchange)];
        self.title = _exchange.name;
        self.APIKey = _exchange.APIKey;
        self.secretKey = _exchange.secretKey;
        self.CNYRate = _exchange.CNYRate;
        self.viewControllerClass = [EXExchangeViewController class];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.saveCommand = [[RACCommand alloc] initWithEnabled:[[RACObserve(self, secretKey) mapStringLength] mapGreaterZero] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.exchange.APIKey = self.APIKey;
        self.exchange.secretKey = self.secretKey;
        self.exchange.CNYRate = self.CNYRate;

        return [RACSignal return:self.exchange];
    }];

    self.scanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        EXQRCodeViewModel *viewModel = [[EXQRCodeViewModel alloc] initWithServices:self.services params:nil];
        viewModel.callback = ^(NSString *string) {
            @strongify(self);
            [[self services] popViewModelAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _scanCompleteWithString:string];
            });
        };
        [[self services] pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(EXExchange *exchange) {
        return [RACSignal defer:^RACSignal * _Nonnull{
            __block BOOL state = NO;
            [EXSocketManager sync:^(EXDelegatesAccessor<EXSocketManager> *accessor) {
                state = [accessor loginWithExchange:exchange];
            }];
            if (state) return [RACSignal return:exchange];
            else return [RACSignal error:[NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Failed to login server."}]];
        }];
    }];
    
    [[[[self loginCommand] executionSignals] switchToLatest] subscribeNext:^(EXExchange *exchange) {
        @strongify(self);
        [self _completeWithExchange:exchange];
    }];
    
    [self.saveCommand.executionSignals.switchToLatest subscribeToCommand:self.loginCommand];
    [self.loginCommand.errors subscribe:self.errors];
}

#pragma mark - private

- (void)_completeWithExchange:(EXExchange *)exchange{
    if (self.callback) self.callback(exchange);
}

- (void)_scanCompleteWithString:(NSString *)string{
    NSDictionary *JSONObject = [string objectFromJSONString];
    if (JSONObject) {
        self.APIKey = JSONObject[EXExchangeViewModelAPIKey];
        self.secretKey = JSONObject[EXExchangeViewModelSecretKey];
    } else {
        NSError *error = [NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"扫描结果异常", NSLocalizedFailureReasonErrorKey: ntoe(string)}];
        [self.errors sendNext:error];
    }
}

@end
