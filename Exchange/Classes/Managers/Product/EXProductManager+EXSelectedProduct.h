//
//  EXProductManager+EXSelectedProduct.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/28.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"

@interface EXProductManager (EXSelectedProduct)

- (void)_saveCollectedProduct;
- (void)_readCollectedProduct;

- (void)_respondDelegateForCollectedSymbol:(NSString *)symbol;
- (void)_respondDelegateForDescollectedSymbol:(NSString *)symbol;

@end
