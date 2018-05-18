//
//  EXDatabaseAccessor+EXLoaderItem.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/15.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <FMDB/FMDB.h>
#import <MDObjectDatabase/MDObjectDatabase.h>

#import "EXDatabaseAccessor+EXLoaderItem.h"
#import "EXProduct.h"
#import "EXBalance.h"
#import "EXTicker.h"
#import "EXDepth.h"
#import "EXTrade.h"
#import "EXOrder.h"
#import "EXWithdraw.h"
#import "EXAccountRecord.h"
#import "EXKLineMetadata.h"

@interface FMDatabaseQueue (EXDatabaseAccessor) <MDDReferenceDatabaseQueue>
@end
@implementation FMDatabaseQueue (EXDatabaseAccessor)
@end

@interface FMDatabase (EXDatabaseAccessor) <MDDReferenceDatabase>
@end
@implementation FMDatabase (EXDatabaseAccessor)
@end

@interface FMResultSet (EXDatabaseAccessor) <MDDReferenceDatabaseResultSet>
@end
@implementation FMResultSet (EXDatabaseAccessor)

- (void *)statementData{
    return [[self statement] statement];
}

@end

@interface EXModel (EXDatabaseAccessor) <MDDObject>
@end
@implementation EXModel (EXDatabaseAccessor)

- (id)JSONObject{
    return self.yy_modelToJSONObject;
}

- (NSString *)JSONString{
    return self.yy_modelToJSONString;
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;{
    return [self modelWithDictionary:dictionary];
}

@end

@implementation EXProduct (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXProduct *product;
    return @{
             @keypath(product, objectID): @"id",
              @keypath(product, symbol): @"symbol",
              @keypath(product, minimumUnit): @"minimum_unit",
              @keypath(product, precision): @"precision",
              @keypath(product, exchangeDomain): @"exchange_domain",
              @keypath(product, collected): @"collected",
              };
}
@end

@implementation EXBalance (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXBalance *balance;
    return @{
              @keypath(balance, symbol): @"symbol",
              @keypath(balance, exchangeDomain): @"exchange_domain",
              @keypath(balance, borrow): @"borrow",
              @keypath(balance, free): @"free",
              @keypath(balance, freezed): @"freezed",
              @keypath(balance, symbol): @"symbol",
              };
}
@end

@implementation EXTicker (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXTicker *ticker;
    return @{
              @keypath(ticker, symbol): @"symbol",
              @keypath(ticker, exchangeDomain): @"exchange_domain",
              @keypath(ticker, openPrice): @"open",
              @keypath(ticker, closePrice): @"close",
              @keypath(ticker, currentBuyPrice): @"buy",
              @keypath(ticker, currentSellPrice): @"sell",
              @keypath(ticker, highestPrice): @"high",
              @keypath(ticker, lowestPrice): @"low",
              @keypath(ticker, lastestPrice): @"last",
              @keypath(ticker, volume): @"vol",
              @keypath(ticker, offset): @"change",
              @keypath(ticker, dayLowPrice): @"dayLow",
              @keypath(ticker, dayHightPrice): @"dayHigh",
              @keypath(ticker, time): @"timestamp",
              };
}
@end

@implementation EXDepth (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXDepth *depth;
    return @{
             @keypath(depth, objectID): @"id",
              @keypath(depth, symbol): @"symbol",
              @keypath(depth, exchangeDomain): @"exchange_domain",
              @keypath(depth, volume): @"volume",
              @keypath(depth, price): @"price",
              @keypath(depth, buy): @"buy",
              };
}
@end

@implementation EXTrade (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXTrade *trade;
    return @{
             @keypath(trade, objectID): @"id",
              @keypath(trade, symbol): @"symbol",
              @keypath(trade, exchangeDomain): @"exchange_domain",
              @keypath(trade, price): @"price",
              @keypath(trade, amount): @"amount",
              @keypath(trade, time): @"date_ms",
              @keypath(trade, type): @"type",
              };
}
@end

@implementation EXOrder (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXOrder *order;
    return @{
             @keypath(order, objectID): @"id",
              @keypath(order, type): @"type",
              @keypath(order, symbol): @"symbol",
              @keypath(order, exchangeDomain): @"exchange_domain",
              @keypath(order, status): @"status",
              @keypath(order, amount): @"amount",
              @keypath(order, dealAmount): @"deal_amount",
              @keypath(order, price): @"price",
              @keypath(order, unitPrice): @"unit_price",
              @keypath(order, averagePrice): @"avg_price",
              @keypath(order, time): @"create_date",
              };
}
@end

@implementation EXWithdraw (EXDatabaseAccessor)
+ (NSDictionary *)databaseMapper{
    EXWithdraw *withdraw;
    return [[self modelCustomPropertyMapper] dictionaryByAddingDictionary:
            @{
              @keypath(withdraw, objectID): @"id",
               @keypath(withdraw, symbol): @"symbol",
               @keypath(withdraw, exchangeDomain): @"exchange_domain",
               @keypath(withdraw, address): @"address",
               @keypath(withdraw, amount): @"amount",
               @keypath(withdraw, fee): @"chargefee",
               @keypath(withdraw, status): @"status",
               @keypath(withdraw, time): @"created_date",
               }];
}
@end

@implementation EXDatabaseAccessor (EXLoaderItem)

- (void)install{
    NSString *folder = SDDocumentFile(@"db");
    BOOL directory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&directory] || !directory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filepath = [folder stringByAppendingPathComponent:@"com.markejave.modool.exchange.db"];
    NSLog(@"\nDatabase file: %@", filepath);
    MDDatabaseCenter *center = [MDDatabaseCenter defaultCenter];
    center.debugEnable = YES;

    FMDatabaseQueue *databaseQueue = [[FMDatabaseQueue alloc] initWithPath:filepath];
    self.database = [center requrieDatabaseWithDatabaseQueue:databaseQueue];

    NSError *error = nil;
    MDDTableConfiguration *tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXProduct class] name:@"t_product" propertyMapper:[EXProduct databaseMapper] autoincrement:NO primaryProperty:@"objectID"];
    [self.database addTableConfiguration:tableConfiguration error:&error];
    
    tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXTicker class] name:@"t_ticker" propertyMapper:[EXTicker databaseMapper] primaryProperties:[NSSet setWithArray:@[@"symbol", @"exchangeDomain"]]];
    [self.database addTableConfiguration:tableConfiguration error:&error];
    tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXBalance class] name:@"t_balance" propertyMapper:[EXTicker databaseMapper] primaryProperties:[NSSet setWithArray:@[@"symbol", @"exchangeDomain"]]];
    [self.database addTableConfiguration:tableConfiguration error:&error];

    tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXTrade class] name:@"t_trade" propertyMapper:[EXTrade databaseMapper] primaryProperty:@"objectID"];
    [self.database addTableConfiguration:tableConfiguration error:&error];
    
    tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXOrder class] name:@"t_order" propertyMapper:[EXOrder databaseMapper] primaryProperty:@"objectID"];
    [self.database addTableConfiguration:tableConfiguration error:&error];
    
    tableConfiguration = [MDDTableConfiguration configurationWithClass:[EXWithdraw class] name:@"t_withdraw" propertyMapper:[EXWithdraw databaseMapper] primaryProperty:@"objectID"];
    [self.database addTableConfiguration:tableConfiguration error:&error];
    
    [self.database prepareWithError:&error];
}

@end
