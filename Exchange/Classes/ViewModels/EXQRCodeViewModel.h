//
//  EXQRCodeViewModel.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACControllerViewModel.h"

@class EXQRCodeScaner;
@interface EXQRCodeViewModel : RACControllerViewModel

@property (nonatomic, strong, readonly) RACCommand *cancelCommand;

@property (nonatomic, strong, readonly) EXQRCodeScaner *scaner;

@end
