//
//  ACArchiverCenter+EXDefault.m
//  Exchange
//
//  Created by Jave on 2018/1/25.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "ACArchiverCenter+EXDefault.h"

@implementation ACArchiverCenter (EXDefault)

+ (NSString *)identifier{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (id<ACArchiveStorage>)defaultDeviceStorage;{
    return [[ACArchiverCenter defaultCenter] requireStorageWithName:[self identifier]];
}

@end
