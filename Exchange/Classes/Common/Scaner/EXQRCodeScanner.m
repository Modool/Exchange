//
//  EXQRCodeScanner.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "EXQRCodeScanner.h"

@interface EXQRCodeScanner () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation EXQRCodeScanner

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset metadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes; {
    NSCParameterAssert(sessionPreset);
    NSCParameterAssert(metadataObjectTypes);
    if (self = [super init]) {
        _sessionPreset = sessionPreset;
        _metadataObjectTypes = metadataObjectTypes;
        
        [self initialize];
    }
    return self;
}

- (void)initialize{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = _sessionPreset;
    
    [_session addOutput:_videoDataOutput];
    [_session addOutput:_metadataOutput];
#if !TARGET_OS_SIMULATOR
    [_session addInput:_deviceInput];
#endif
    
    NSSet<AVMetadataObjectType> *availableTypes = [NSSet setWithArray:[_metadataOutput availableMetadataObjectTypes]];
    NSMutableSet<AVMetadataObjectType> *types = [NSMutableSet setWithArray:_metadataObjectTypes];
    [types intersectSet:availableTypes];
    
    _metadataOutput.metadataObjectTypes = types.allObjects;
    
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)dealloc{
    [_session stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    [_metadataOutput setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanner:didOutputMetadataObjects:)]) {
        [self.delegate scanner:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate的方法

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanner:brightnessValue:)]) {
        [self.delegate scanner:self brightnessValue:brightnessValue];
    }
}

- (void)startInView:(UIView *)view{
    [self startInView:view immediately:YES];
}

- (void)startInView:(UIView *)view immediately:(BOOL)immediately; {
    NSCParameterAssert(view);
    
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

+ (NSString *)stringValueFromQRCodeImage:(UIImage *)QRCodeImage;{
    CIImage *image = [CIImage imageWithCGImage:QRCodeImage.CGImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIQRCodeFeature *feature = (id)[[detector featuresInImage:image] firstObject];
    
    return feature.messageString;
}

+ (UIImage *)QRCodeImageFromString:(NSString *)string;{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *dataFilter = [CIFilter filterWithName:@"CIQRCodeGenerator" keysAndValues:@"inputMessage", data, @"inputCorrectionLevel", @"M", nil];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", dataFilter.outputImage, @"inputColor0", [CIColor colorWithCGColor:UIColor.redColor.CGColor], @"inputColor1", [CIColor colorWithCGColor:UIColor.blueColor.CGColor], nil];
    
    CIImage *image = colorFilter.outputImage;
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), imageRef);
    
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    
    return codeImage;
}

@end

