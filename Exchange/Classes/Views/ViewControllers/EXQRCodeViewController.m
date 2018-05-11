
//
//  EXQRCodeViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXQRCodeViewController.h"
#import "EXQRCodeViewModel.h"

#import "EXQRCodeScaner.h"

@interface EXQRCodeViewController ()

@property (nonatomic, strong, readonly) EXQRCodeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;

@end

@implementation EXQRCodeViewController
@dynamic viewModel;

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    self.navigationItem.leftBarButtonItem = [self cancelBarButtonItem];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBackgroundView:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewModel.scaner startInView:self.view immediately:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.scaner resume];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewModel.scaner pause];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    self.cancelBarButtonItem.rac_command = [[self viewModel] cancelCommand];
}

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
