
//
//  EXProductManager+Private.h
//  Exchange
//
//  Created by xulinfeng on 2018/4/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductManager.h"
#import "EXProduct.h"
#import "EXBalance+Private.h"

@interface EXProductManager () <EXProductManager>

@property (nonatomic, strong, readonly) MDMulticastDelegate<EXProductManagerDelegate> *delegates;

@property (nonatomic, strong) NSMutableDictionary<NSString *, MDMulticastDelegate<EXProductManagerSymbolDelegate> *> *symbolDelegates;

@property (nonatomic, strong) NSMutableDictionary<NSString *, EXProduct *> *products;

@property (nonatomic, strong) NSArray<NSString *> *allSymbols;
@property (nonatomic, strong) NSArray<EXProduct *> *allProducts;

@property (nonatomic, strong) NSMutableArray<NSString *> *collectedSymbols;

@property (nonatomic, strong) EXBalance *balance;
@property (nonatomic, strong) NSMutableDictionary<NSString *, EXBalance *> *mutableBalances;

@property (nonatomic, strong) NSMutableDictionary<NSString *, EXOrder *> *mutableOrders;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, EXOrder *> *> *orders;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<EXTrade *> *> *trades;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<EXKLineMetadata *> *> *lines;

@property (nonatomic, strong) NSMutableDictionary<NSString *, EXTicker *> *tickers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, EXDepth *> *depths;

- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_nonNullDelegatesForSymbol:(NSString *)symbol;
- (MDMulticastDelegate<EXProductManagerSymbolDelegate> *)_delegatesForSymbol:(NSString *)symbol;

- (NSDictionary<NSString *, EXBalance *> *)_synchronizeRemoteBalances;

@end
