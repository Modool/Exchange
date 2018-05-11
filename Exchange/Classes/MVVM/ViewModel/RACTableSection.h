//
//  RACTableSection.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "RACViewModel.h"

@protocol RACTableRow <NSObject>

@end

@protocol RACTableSection <NSObject>

@property (nonatomic, copy) NSString *header;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, copy) NSString *footer;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong) Class headerViewClass;
@property (nonatomic, strong) Class footerViewClass;

@property (nonatomic, copy) NSArray *viewModels;

@end

@interface RACTableSection : RACViewModel<RACTableSection>

+ (instancetype)sectionWithViewModels:(NSArray *)viewModels;
- (instancetype)initWithViewModels:(NSArray *)viewModels;

@end
