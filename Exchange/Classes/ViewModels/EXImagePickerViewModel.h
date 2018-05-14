//
//  EXImagePickerViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/14.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"

@interface EXImagePickerViewModel : RACControllerViewModel<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong, readonly) RACCommand *takePictureCommand;
@property (nonatomic, strong, readonly) RACCommand *startVideoCaptureCommand;
@property (nonatomic, strong, readonly) RACCommand *stopVideoCaptureCommand;

@property(nonatomic, copy)   NSArray<NSString *> *mediaTypes;

@property(nonatomic, assign) UIImagePickerControllerSourceType   sourceType;
@property(nonatomic, assign) UIImagePickerControllerImageURLExportPreset imageExportPreset NS_AVAILABLE_IOS(11_0);

@property(nonatomic, assign) BOOL allowsEditing;
@property(nonatomic, assign) BOOL showsCameraControls;

@property(nonatomic, copy)   NSString *videoExportPreset NS_AVAILABLE_IOS(11_0);
@property(nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property(nonatomic, assign) UIImagePickerControllerQualityType videoQuality;

@property(nonatomic, strong) __kindof UIView *cameraOverlayView;
@property(nonatomic, assign) CGAffineTransform cameraViewTransform;

@property(nonatomic, assign) UIImagePickerControllerCameraDevice      cameraDevice;
@property(nonatomic, assign) UIImagePickerControllerCameraFlashMode   cameraFlashMode;
@property(nonatomic, assign) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;

@property (nonatomic, copy) void (^imagePicker)(UIImage *image, NSDictionary *info);
@property (nonatomic, copy) void (^mediaPicker)(NSDictionary *info);

@end
