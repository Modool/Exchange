
//
//  EXImagePickerViewModel.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/14.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXImagePickerViewModel.h"
#import "EXImagePickerController.h"

@interface EXImagePickerViewModel ()

@property (nonatomic, strong) RACCommand *takePictureCommand;
@property (nonatomic, strong) RACCommand *startVideoCaptureCommand;
@property (nonatomic, strong) RACCommand *stopVideoCaptureCommand;

@end

@implementation EXImagePickerViewModel

- (instancetype)initWithServices:(id<RACViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.viewControllerClass = [EXImagePickerController class];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.takePictureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
    
    self.startVideoCaptureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
    
    self.stopVideoCaptureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
    
    [[self rac_signalForSelector:@selector(imagePickerControllerDidCancel:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [[self services] dismissViewModelAnimated:YES completion:nil];
    }];
    
    [[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingImage:editingInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if (self.imagePicker) self.imagePicker(tuple.second, tuple.third);
    }];
    
    [[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if (self.mediaPicker) self.mediaPicker(tuple.second);
    }];
}

@end
