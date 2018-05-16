//
//  EXDatabaseAccessor.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDatabaseAccessor.h"
#import "EXDelegatesAccessor+EXAccessors.h"

@interface EXDatabaseAccessor()

@property (nonatomic, strong, readonly) MDDatabase *database;

@end

@implementation EXDatabaseAccessor

+ (MDDatabase *)database{
    __block MDDatabase *database = nil;
    
    EXDatabaseAccessor *accessor = [EXDelegatesAccessor accessorForClass:self];
    [accessor sync:^{
        database = accessor.database;
    }];
    return database;
}

@end
