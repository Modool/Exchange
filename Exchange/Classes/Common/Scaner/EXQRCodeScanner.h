//
//  EXQRCodeScanner.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class EXQRCodeScanner;
@protocol EXQRCodeScannerDelegate <NSObject>

@optional
- (void)scanner:(EXQRCodeScanner *)scanner didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects;

- (void)scanner:(EXQRCodeScanner *)scanner brightnessValue:(CGFloat)brightnessValue;

@end

@interface EXQRCodeScanner : NSObject

@property (nonatomic, weak) id<EXQRCodeScannerDelegate> delegate;

@property (nonatomic, copy, readonly) AVCaptureSessionPreset sessionPreset;

@property (nonatomic, copy, readonly) NSArray<AVMetadataObjectType> *metadataObjectTypes;

@property (nonatomic, strong, readonly) AVCaptureSession *session;
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

- (void)startInView:(UIView *)view;
- (void)startInView:(UIView *)view immediately:(BOOL)immediately;
- (void)pause;
- (void)resume;
- (void)stop;

+ (NSString *)stringValueFromQRCodeImage:(UIImage *)QRCodeImage;
+ (UIImage *)QRCodeImageFromString:(NSString *)string;

@end
