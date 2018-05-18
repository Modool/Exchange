//
//  EXLoaderItem.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EXLoaderItem <NSObject>

@property (strong, nonatomic, readonly) dispatch_queue_t queue;

@optional
- (void)reload;

- (void)install;

- (void)uninstall;

@end

@class EXCompatQueue;
@protocol EXLoaderCompatItem <NSObject>

@property (nonatomic, copy, readonly) EXCompatQueue *compatQueue;

@end
