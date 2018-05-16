//
//  EXHTTPClient+Private.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient.h"

@interface EXHTTPClient ()

@property (nonatomic, copy, readonly) NSString *APIKey;
@property (nonatomic, copy, readonly) NSString *secretKey;

- (instancetype)initWithExchange:(EXExchange *)exchange;

@end

@interface EXBinanceHTTPClient : EXHTTPClient

@end

@interface EXOKExHTTPClient : EXHTTPClient

@end

@interface EXBitfinexHTTPClient : EXHTTPClient

@end

@interface EXHuobiHTTPClient : EXHTTPClient

@end
