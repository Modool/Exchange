//
//  EXOperation+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/3.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXOperation.h"

@interface EXOperation ()

@property (nonatomic, assign, getter=isConcurrent) BOOL concurrent;

@property (nonatomic, copy) void (^block)(EXOperation *operation);

@end

@interface EXOperation (Private)

- (void)main;
- (void)run;

@end
