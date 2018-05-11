//
//  RACCommand+RACMap.h
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACCommand (RACMap)

- (RACCommand *)flattenMapInput:(id)input;

@end
