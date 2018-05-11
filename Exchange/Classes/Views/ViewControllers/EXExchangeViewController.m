//
//  EXExchangeViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXExchangeViewController.h"
#import "EXExchangeViewModel.h"

@interface EXExchangeViewController ()

@property (nonatomic, strong, readonly) EXExchangeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;

@property (nonatomic, strong) UILabel *appkeyTitleLabel;
@property (nonatomic, strong) UITextField *appkeyTextField;

@property (nonatomic, strong) UILabel *secretkeyTitleLabel;
@property (nonatomic, strong) UITextField *secretKeyTextField;

@property (nonatomic, strong) UILabel *rateTitleLabel;
@property (nonatomic, strong) UITextField *rateTextField;

@property (nonatomic, strong) UIButton *scanButton;

@end

@implementation EXExchangeViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    self.saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:nil];
    self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
    
    self.appkeyTitleLabel = [[UILabel alloc] init];
    self.appkeyTitleLabel.text = @"API Key";
    self.appkeyTitleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:self.appkeyTitleLabel];
    
    self.appkeyTextField = [[UITextField alloc] init];
    self.appkeyTextField.font = [UIFont systemFontOfSize:12];
    self.appkeyTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.appkeyTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.appkeyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:self.appkeyTextField];
    
    self.secretkeyTitleLabel = [[UILabel alloc] init];
    self.secretkeyTitleLabel.text = @"Secret Key";
    self.secretkeyTitleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:self.secretkeyTitleLabel];
    
    self.secretKeyTextField = [[UITextField alloc] init];
    self.secretKeyTextField.font = [UIFont systemFontOfSize:12];
    self.secretKeyTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.secretKeyTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.secretKeyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:self.secretKeyTextField];
    
    self.rateTitleLabel = [[UILabel alloc] init];
    self.rateTitleLabel.text = @"汇率 USDT/CNY";
    self.rateTitleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:self.rateTitleLabel];
    
    self.rateTextField = [[UITextField alloc] init];
    self.rateTextField.font = [UIFont systemFontOfSize:12];
    self.rateTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.rateTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.rateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:self.rateTextField];
    
    self.scanButton = [[UIButton alloc] init];
    self.scanButton.layer.borderWidth = 1.f;
    self.scanButton.layer.cornerRadius = 4.f;
    self.scanButton.layer.borderColor = [[UIColor blueColor] CGColor];
    [self.scanButton setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [self.scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.scanButton];

    [self _installConstraints];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.saveBarButtonItem.rac_command = self.viewModel.saveCommand;
    self.scanButton.rac_command = self.viewModel.scanCommand;
    
    RACChannelTerminal *channal1 = RACChannelTo(self.viewModel, APIKey);
    RACChannelTerminal *channal2 = RACChannelTo(self.appkeyTextField, text);;
    RACChannelTerminal *channal3 = self.appkeyTextField.rac_newTextChannel;
    
    [channal1 subscribe:channal2];
    [channal3 subscribe:channal1];
    
    channal1 = RACChannelTo(self.viewModel, secretKey);
    channal2 = RACChannelTo(self.secretKeyTextField, text);;
    channal3 = self.secretKeyTextField.rac_newTextChannel;
    
    [channal1 subscribe:channal2];
    [channal3 subscribe:channal1];
    
    channal1 = RACChannelTo(self.viewModel, CNYRate);
    channal2 = RACChannelTo(self.rateTextField, text);;
    channal3 = self.rateTextField.rac_newTextChannel;
    
    [[channal1 map:^id(NSNumber *value) {
        return fmts(@"%.8f", value.doubleValue);
    }] subscribe:channal2];
    
    [[channal3 map:^id(NSString *text) {
        return @(text.doubleValue);
    }] subscribe:channal1];
}

#pragma mark - private

- (void)_installConstraints{
    [self.appkeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.appkeyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appkeyTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(44);
    }];
    
    [self.secretkeyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appkeyTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.secretKeyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secretkeyTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(44);
    }];
    
    [self.rateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secretKeyTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.rateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(44);
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(44);
    }];
}

@end
