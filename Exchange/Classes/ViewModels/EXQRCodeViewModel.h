//
//  EXQRCodeViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"

@class EXQRCodeScanner;
@interface EXQRCodeViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) RACCommand *imagePickerCommand;
@property (nonatomic, strong, readonly) RACCommand *scanImageCommand;

@property (nonatomic, strong, readonly) RACCommand *startCommand;

@property (nonatomic, strong, readonly) EXQRCodeScanner *scanner;

@end
