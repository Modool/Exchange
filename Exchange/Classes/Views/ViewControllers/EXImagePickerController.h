//
//  EXImagePickerController.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/14.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXImagePickerViewModel.h"

@interface EXImagePickerController : UIImagePickerController<RACViewController>

@property (nonatomic, strong, readonly) EXImagePickerViewModel *viewModel;

@end
