//
//  EXKeychain.h
//  Exchange
//
//  Created by Jave on 2018/1/22.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXKeychain : NSObject

+ (NSString *)passwordForKey:(NSString *)key;
+ (void)setPassword:(NSString *)password forKey:(NSString *)key;

@end
