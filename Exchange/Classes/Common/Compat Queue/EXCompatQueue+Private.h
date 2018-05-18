//
//  EXCompatQueue+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/10.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatQueue.h"

@interface EXCompatQueue (){
    NSString *_key;
    CGFloat _currentVersion;
}

@property (assign) CGFloat localVersion;

@end
