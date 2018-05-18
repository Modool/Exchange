//
//  EXCompatOperation+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/12.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXCompatOperation.h"

@interface EXCompatOperation (){
    CGFloat _version;
    CGFloat _localVersion;
    CGFloat _currentVersion;
    void (^_compatBlock)(EXCompatOperation *operation, CGFloat version, CGFloat localVersion);
}

@end
