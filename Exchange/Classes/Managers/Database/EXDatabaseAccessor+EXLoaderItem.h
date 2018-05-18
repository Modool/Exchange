//
//  EXDatabaseAccessor+EXLoaderItem.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXDatabaseAccessor.h"
#import "EXLoaderItem.h"

@interface EXDatabaseAccessor()

@property (nonatomic, strong) MDDatabase *database;

@end

@interface EXDatabaseAccessor (EXLoaderItem)<EXLoaderItem>

@end
