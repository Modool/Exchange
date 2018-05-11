//
//  EXQRCodeViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXQRCodeViewModel.h"
#import "EXQRCodeViewController.h"
#import "EXQRCodeScaner.h"

@interface EXQRCodeViewModel ()<EXQRCodeScanerDelegate>

@property (nonatomic, strong) RACCommand *cancelCommand;

@property (nonatomic, strong) EXQRCodeScaner *scaner;

@end

@implementation EXQRCodeViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.viewControllerClass = EXClass(EXQRCodeViewController);
        self.scaner = [[EXQRCodeScaner alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        self.scaner.delegate = self;
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.scaner stop];
        [self.services dismissViewModelAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    
    [[self rac_signalForSelector:@selector(scaner:didOutputMetadataObjects:) fromProtocol:@protocol(EXQRCodeScanerDelegate)] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(EXQRCodeScaner *scaner, NSArray<AVMetadataMachineReadableCodeObject *> *objects) = tuple;
        AVMetadataMachineReadableCodeObject *object = objects.firstObject;
        NSString *stringValue = object.stringValue;
        if (!stringValue.length) return;
        
        @strongify(self);
        [scaner stop];
        [self _completeWithStringValue:stringValue];
    }];
}

#pragma mark - private

- (void)_completeWithStringValue:(NSString *)stringValue{
    if (self.callback) self.callback(stringValue);
}

@end
