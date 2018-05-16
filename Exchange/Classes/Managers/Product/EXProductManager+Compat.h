//
//  EXProductManager+Compat.h
//  Exchange
//
//  Created by xulinfeng on 2018/5/16.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"
#import "EXCompatOperation.h"

@interface EXProductManager (Compat)

+ (NSArray<EXCompatOperation *> *)compatOperations;

@end
