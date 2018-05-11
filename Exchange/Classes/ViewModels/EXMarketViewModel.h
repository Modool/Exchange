//
//  EXMarketViewModel.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "RACMultipleViewModel.h"

@interface EXMarketViewModel : RACMultipleViewModel

@property (nonatomic, strong, readonly) RACCommand *searchCommand;

@end
