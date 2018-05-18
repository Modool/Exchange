//
//  EXDepthChartViewController.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/17.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDepthChartViewController.h"
#import "EXDepthChartViewModel.h"

#import "EXTimer.h"

@interface EXDepthShadowView : UIView

@property (nonatomic, strong) CAShapeLayer *askLayer;
@property (nonatomic, strong) CAShapeLayer *bidLayer;

@property (nonatomic, assign) double minimumPrice;
@property (nonatomic, assign) double maximumPrice;

@property (nonatomic, assign) double minimumVolume;

@end

@implementation EXDepthShadowView

@end

@interface EXDepthChartViewController ()

@property (nonatomic, strong, readonly) EXDepthChartViewModel *viewModel;

@property (nonatomic, strong) EXDepthShadowView *shadowView;

@property (nonatomic, strong) EXTimer *timer;

@end

@implementation EXDepthChartViewController
@dynamic viewModel;

- (instancetype)initWithViewModel:(RACControllerViewModel *)viewModel{
    if (self = [super initWithViewModel:viewModel]) {
        self.timer = [EXTimer timerWithInterval:2 target:self action:@selector(didTimerUpdate:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.timer schedule];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer stop];
}

#pragma mark - actions

- (IBAction)didTimerUpdate:(id)sender{
    [self.shadowView setNeedsLayout];
    
    self.shadowView.askLayer.path = self.viewModel.askBezierPath.CGPath;
    self.shadowView.bidLayer.path = self.viewModel.bidBezierPath.CGPath;
}

@end
