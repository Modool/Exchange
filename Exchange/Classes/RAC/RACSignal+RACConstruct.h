//
//  RACSignal+RACConstruct.h
//  Exchange
//
//  Created by Jave on 2018/1/17.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal<__covariant ValueType> (RACConstruct)

+ (RACSignal<ValueType> *)createDispersedSignal:(void(^)(id<RACSubscriber> subscriber))didSubscribe;

@end
