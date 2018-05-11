//
//  EXQRCodeScaner.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class EXQRCodeScaner;
@protocol EXQRCodeScanerDelegate <NSObject>

@optional
- (void)scaner:(EXQRCodeScaner *)scaner didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects;

- (void)scaner:(EXQRCodeScaner *)scaner brightnessValue:(CGFloat)brightnessValue;

@end

@interface EXQRCodeScaner : NSObject

@property (nonatomic, weak) id<EXQRCodeScanerDelegate> delegate;

@property (nonatomic, copy, readonly) AVCaptureSessionPreset sessionPreset;

@property (nonatomic, copy, readonly) NSArray<AVMetadataObjectType> *metadataObjectTypes;

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

- (void)startInView:(UIView *)view;
- (void)startInView:(UIView *)view immediately:(BOOL)immediately;
- (void)pause;
- (void)resume;
- (void)stop;

@end
