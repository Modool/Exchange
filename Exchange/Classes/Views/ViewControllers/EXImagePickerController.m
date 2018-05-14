//
//  EXImagePickerController.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/14.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXImagePickerController.h"

@interface EXImagePickerController ()

@property (nonatomic, strong) EXImagePickerViewModel *viewModel;

@end

@implementation EXImagePickerController

- (instancetype)init {
    return [self initWithViewModel:nil];
}

- (instancetype)initWithViewModel:(EXImagePickerViewModel *)viewModel {
    NSAssert(viewModel, @"View model must be nonull.");
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.delegate = viewModel;
        self.sourceType = viewModel.sourceType;
        self.allowsEditing = viewModel.allowsEditing;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        if (viewModel.mediaTypes.count) {
            NSSet *availableTypes = [NSSet setWithArray:[UIImagePickerController availableMediaTypesForSourceType:viewModel.sourceType]];
            NSMutableSet *types = [NSMutableSet setWithArray:viewModel.mediaTypes];
            [types intersectSet:availableTypes];
            
            self.mediaTypes = types.allObjects;
        }
        
        if (@available(iOS 11, *)) {
            self.imageExportPreset = viewModel.imageExportPreset;
        }
        
        if (viewModel.sourceType == UIImagePickerControllerSourceTypeCamera) {
            self.showsCameraControls = viewModel.showsCameraControls;
            self.videoMaximumDuration = viewModel.videoMaximumDuration;
            self.videoQuality = viewModel.videoQuality;
            
            self.cameraOverlayView = viewModel.cameraOverlayView;
            self.cameraViewTransform = viewModel.cameraViewTransform;
            
            self.cameraDevice = viewModel.cameraDevice;
            self.cameraFlashMode = viewModel.cameraFlashMode;
            self.cameraCaptureMode = viewModel.cameraCaptureMode;
            
            if (@available(iOS 11, *)) {
                self.videoExportPreset = viewModel.videoExportPreset;
            }
        }
        
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeToSubject:viewModel.didLoadViewSignal input:nil];
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeToSubject:viewModel.willAppearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewDidAppear:)] subscribeToSubject:viewModel.didAppearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeToSubject:viewModel.willDisappearSignal input:nil];
        [[self rac_signalForSelector:@selector(viewDidDisappear:)] subscribeToSubject:viewModel.didDisappearSignal input:nil];
    }
    return self;
}

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.takePictureCommand.executionSignals.switchToLatest subscribeToTarget:self performSelector:@selector(takePicture)];
    [self.viewModel.startVideoCaptureCommand.executionSignals.switchToLatest subscribeToTarget:self performSelector:@selector(startVideoCapture)];
    [self.viewModel.stopVideoCaptureCommand.executionSignals.switchToLatest subscribeToTarget:self performSelector:@selector(stopVideoCapture)];
    
    [[[self viewModel] errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD showText:error.localizedDescription inView:[self view]];
    }];
}

- (void)dealloc {
    self.viewModel = nil;
}

@end
