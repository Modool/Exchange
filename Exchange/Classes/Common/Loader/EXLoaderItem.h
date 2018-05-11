//
//  EXLoaderItem.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EXLoaderItem <NSObject>

@optional

- (void)reload;

- (void)install;

- (void)uninstall;

@end
