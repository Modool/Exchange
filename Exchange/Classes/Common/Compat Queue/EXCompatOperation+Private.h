//
//  EXCompatOperation+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/12.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatOperation.h"

@interface EXCompatOperation ()

@property (nonatomic, assign) CGFloat version;

@property (nonatomic, copy) void (^compatBlock)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion);

- (void)_prepareCompatWithCurrentVersion:(CGFloat)currentVersion localVersion:(CGFloat)localVersion;

@end
