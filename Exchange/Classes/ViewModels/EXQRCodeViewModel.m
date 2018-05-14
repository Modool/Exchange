//
//  EXQRCodeViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "EXQRCodeViewModel.h"
#import "EXQRCodeViewController.h"
#import "EXImagePickerViewModel.h"

#import "EXQRCodeScanner.h"

@interface EXQRCodeViewModel ()<EXQRCodeScannerDelegate>

@property (nonatomic, strong) RACCommand *imagePickerCommand;
@property (nonatomic, strong) RACCommand *scanImageCommand;
@property (nonatomic, strong) RACCommand *startCommand;

@property (nonatomic, strong) EXQRCodeScanner *scanner;

@end

@implementation EXQRCodeViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.title = @"扫描二维码";
        self.viewControllerClass = EXClass(EXQRCodeViewController);
        self.scanner = [[EXQRCodeScanner alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        self.scanner.delegate = self;
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.imagePickerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self imagePickerSignal] takeUntil:self.rac_willDeallocSignal];
    }];
    
    self.scanImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *image) {
        return [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSString *string = [self.scanner.class stringValueFromQRCodeImage:image];
            [[[RACSignal return:string] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
        }];
    }];
    
    self.startCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIView *view) {
        @strongify(self);
        return [[self startSignalWithScanner:self.scanner inView:view] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [[self rac_signalForSelector:@selector(scanner:didOutputMetadataObjects:) fromProtocol:@protocol(EXQRCodeScannerDelegate)] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(EXQRCodeScanner *scanner, NSArray<AVMetadataMachineReadableCodeObject *> *objects) = tuple;
        AVMetadataMachineReadableCodeObject *object = objects.firstObject;
        NSString *stringValue = object.stringValue;
        if (!stringValue.length) return;
        
        @strongify(self);
        [scanner stop];
        [self _completeWithStringValue:stringValue];
    }];
    
    [self.didAppearSignal subscribeToTarget:self.scanner performSelector:@selector(resume)];
    [self.willDisappearSignal subscribeToTarget:self.scanner performSelector:@selector(pause)];
    [self.rac_willDeallocSignal subscribeToTarget:self.scanner performSelector:@selector(stop)];
    
    [self.scanImageCommand.executionSignals.switchToLatest subscribeToTarget:self performSelector:@selector(_completeWithStringValue:)];
    
    [self.startCommand.errors subscribe:self.errors];
    [self.scanImageCommand.errors subscribe:self.errors];
}

#pragma mark - signal accessor

- (RACSignal *)imagePickerSignal{
    @weakify(self);
    return [[self photoLibraryAuthorizationSignal] flattenMap:^RACSignal *(id value) {
        @strongify(self);
        EXImagePickerViewModel *viewModel = [[EXImagePickerViewModel alloc] initWithServices:self.services params:nil];
        
        viewModel.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        viewModel.mediaPicker = ^(NSDictionary *info) {
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            @strongify(self);
            [self.scanImageCommand execute:image];
            
            [[self services] dismissViewModelAnimated:YES completion:nil];
        };
        [self.services presentViewModel:viewModel animated:YES completion:nil];
        return [RACSignal empty];
    }];
}

- (RACSignal *)photoLibraryAuthorizationSignal{
    return [RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) [[[RACSignal error:[NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"未授权"}]] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
                else [[[RACSignal return:@(status)] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
            }];
        } else {
            [[RACSignal return:@(status)] subscribe:subscriber];
        }
    }];
}

- (RACSignal *)startSignalWithScanner:(EXQRCodeScanner *)scanner inView:(UIView *)view{
    return [[self captureDeviceAuthorizationSignal] flattenMap:^RACSignal *(id value) {
        [scanner startInView:view immediately:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)captureDeviceAuthorizationSignal{
    return [RACSignal createDispersedSignal:^(id<RACSubscriber> subscriber) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) [[[RACSignal return:@(AVAuthorizationStatusAuthorized)] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
                else [[[RACSignal error:[NSError errorWithDomain:EXExchangeErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"未授权"}]] subscribeOn:[RACScheduler mainThreadScheduler]] subscribe:subscriber];
            }];
        } else {
            [[RACSignal return:@(status)] subscribe:subscriber];
        }
    }];
}

#pragma mark - private

- (void)_completeWithStringValue:(NSString *)stringValue{
    if (self.callback) self.callback(stringValue);
}

@end
