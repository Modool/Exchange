//
//  EXQRCodeScaner.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "EXQRCodeScaner.h"

@interface EXQRCodeScaner () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation EXQRCodeScaner

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes; {
    if (!sessionPreset) @throw [NSException exceptionWithName:@"EXQRCodeScaner" reason:@"initWithSessionPreset:metadataObjectType: 方法中的 sessionPreset 参数不能为空" userInfo:nil];
    if (!metadataObjectTypes) @throw [NSException exceptionWithName:@"SGQRCode" reason:@"initWithSessionPreset:metadataObjectTypes: 方法中的 metadataObjectTypes 参数不能为空" userInfo:nil];
    if (self = [super init]) {
        _sessionPreset = sessionPreset;
        _metadataObjectTypes = metadataObjectTypes;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2、创建摄像设备输入流
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 3、创建元数据输出流
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 3(1)、创建摄像数据输出流
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // 4、创建会话对象
    _session = [[AVCaptureSession alloc] init];
    // 会话采集率: AVCaptureSessionPresetHigh
    _session.sessionPreset = _sessionPreset;
    
    // 5、添加元数据输出流到会话对象
    [_session addOutput:metadataOutput];
    // 5(1)添加摄像输出流到会话对象；与 3(1) 构成识了别光线强弱
    [_session addOutput:_videoDataOutput];
    
    // 6、添加摄像设备输入流到会话对象
    [_session addInput:deviceInput];
    
    // @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
    metadataOutput.metadataObjectTypes = _metadataObjectTypes;
    
    // 8、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 保持纵横比；填充层边界
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
}

- (void)dealloc{
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaner:didOutputMetadataObjects:)]) {
        [self.delegate scaner:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate的方法

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 这个方法会时时调用，但内存很稳定
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f", brightnessValue);
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaner:brightnessValue:)]) {
        [self.delegate scaner:self brightnessValue:brightnessValue];
    }
}

- (void)startInView:(UIView *)view{
    [self startInView:view immediately:YES];
}

- (void)startInView:(UIView *)view immediately:(BOOL)immediately; {
    if (!view) @throw [NSException exceptionWithName:@"EXQRCodeScaner" reason:@"startInView: 方法中的 view 参数不能为空" userInfo:nil];
    
    _videoPreviewLayer.frame = view.bounds;
    [_videoPreviewLayer removeFromSuperlayer];
    [view.layer addSublayer:_videoPreviewLayer];
    
    if (!_session.isRunning && immediately) [_session startRunning];
}

- (void)pause;{
    if (_session.isRunning) [_session stopRunning];
}

- (void)resume;{
    if (!_session.isRunning) [_session startRunning];
}

- (void)stop {
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
}

@end

