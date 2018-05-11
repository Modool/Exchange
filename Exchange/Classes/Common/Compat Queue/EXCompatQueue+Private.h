//
//  EXCompatQueue+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatQueue.h"

@interface EXCompatQueue ()

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) CGFloat currentVersion;

@property (nonatomic, assign) CGFloat localVersion;

@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

@end
