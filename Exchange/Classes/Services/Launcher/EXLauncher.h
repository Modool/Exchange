//
//  EXLauncher.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EXDevice;
@interface EXLauncher : NSObject

- (BOOL)launchWithDevice:(EXDevice *)device;

@end
