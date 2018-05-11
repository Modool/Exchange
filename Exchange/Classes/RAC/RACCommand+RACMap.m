//
//  RACCommand+RACMap.m
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACCommand+RACMap.h"

@implementation RACCommand (RACMap)

- (RACCommand *)flattenMapInput:(id)input;{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        @strongify(self);
        return [self execute:input];
    }];
}

@end
