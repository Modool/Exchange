//
//  RACTableSection.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACTableSection.h"

@implementation RACTableSection
@synthesize header, footer, headerHeight, footerHeight, headerViewClass, footerViewClass, viewModels;

+ (instancetype)sectionWithViewModels:(NSArray *)viewModels;{
    return [[self alloc] initWithViewModels:viewModels];
}

- (instancetype)initWithViewModels:(NSArray *)viewModels;{
    if (self = [super init]) {
        self.viewModels = viewModels;
    }
    return self;
}

@end
