
//
//  EXProductManager+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"

@interface EXProductManager () <EXProductManager>

@property (nonatomic, strong, readonly) MDMulticastDelegate<EXProductManagerDelegate> *delegates;

@property (nonatomic, strong) NSMutableDictionary<NSString *, MDMulticastDelegate<EXProductManagerSymbolDelegate> *> *symbolDelegates;

@end

@interface EXProductManager (Private)

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_nonNullDelegatesByProductID:(NSString *)productID;
- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_delegatesByProductID:(NSString *)productID;

- (NSDictionary<NSString *, EXBalance *> *)_synchronizeRemoteBalances;

- (void)_respondDelegateForUpdatedProduct:(EXProduct *)product collected:(BOOL)collected;
- (void)_respondDelegateForUpdatedTicker:(EXTicker *)ticker;
- (void)_respondDelegateForUpdatedBalance:(EXBalance *)balance;

- (void)_respondDelegateForAppendedOrder:(EXOrder *)order;
- (void)_respondDelegateForUpdatedOrder:(EXOrder *)order;
- (void)_respondDelegateForAppendedTrade:(EXTrade *)trade;

- (void)_respondDelegateForUpdatedDepthSet:(EXDepthSet *)depthSet forProductID:(NSString *)productID;

- (void)_respondDelegateForAppendedTrades:(NSArray<EXTrade *> *)trades forProductID:(NSString *)productID;
- (void)_respondDelegateForAppendedKLines:(NSArray<EXKLineMetadata *> *)lines forProductID:(NSString *)productID;

@end
