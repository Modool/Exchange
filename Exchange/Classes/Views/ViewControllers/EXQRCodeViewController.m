
//
//  EXQRCodeViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXQRCodeViewController.h"
#import "EXQRCodeViewModel.h"

#import "EXQRCodeScanner.h"

@interface EXQRCodeViewController ()

@property (nonatomic, strong, readonly) EXQRCodeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *imagePickerBarButtonItem;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;

@end

@implementation EXQRCodeViewController
@dynamic viewModel;

- (instancetype)initWithViewModel:(EXQRCodeViewModel *)viewModel{
    if (self = [super initWithViewModel:viewModel]) {
        @weakify(self);
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple *x) {
            @strongify(self);
            [viewModel.startCommand execute:self.view];
        }];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imagePickerBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [self imagePickerBarButtonItem];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBackgroundView:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    self.imagePickerBarButtonItem.rac_command = [[self viewModel] imagePickerCommand];
    
    __block MBProgressHUD *progressHUD = nil;
    [self.viewModel.scanImageCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) progressHUD = [MBProgressHUD showProgressInView:self.view];
        else [progressHUD hideAnimated:NO];
    }];
}

#pragma mark - accessor

- (BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}

#pragma mark - actions

- (IBAction)didClickBackgroundView:(id)sender{
    BOOL navigationBarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!navigationBarHidden animated:YES];
    
    self.statusBarHidden = !self.statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
