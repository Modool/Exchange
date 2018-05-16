//
//  EXDatabaseAccessor.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDObjectDatabase/MDObjectDatabase.h>
#import "EXDelegatesAccessor.h"

@interface EXDatabaseAccessor : EXDelegatesAccessor

@property (nonatomic, strong, class, readonly) MDDatabase *database;

@end
