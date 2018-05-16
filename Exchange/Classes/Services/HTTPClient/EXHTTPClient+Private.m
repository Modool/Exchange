//
//  EXHTTPClient+Private.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXHTTPClient+Private.h"
#import "NSString+EXAdditions.h"

NSString * EXQueryStringFromParameters(NSDictionary<NSString *, id> *parameters, NSArray<NSString *> *orderKeys) {
    NSArray<NSString *> *keys = orderKeys ?: [parameters allKeys];
    NSMutableArray<NSString *> *queryItems = [NSMutableArray new];
    for (NSString *key in keys) {
        [queryItems addObject:fmts(@"%@=%@", key, [[parameters[key] description] urlEncodeUsingEncoding:NSUTF8StringEncoding])];
    }
    return [queryItems componentsJoinedByString:@"&"];
}

@implementation EXBinanceHTTPClient

- (instancetype)initWithExchange:(EXExchange *)exchange{
    if (self =  [super initWithExchange:exchange]) {
        [[self requestSerializer] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [[self requestSerializer] setValue:[self APIKey] forHTTPHeaderField:@"X-MBX-APIKEY"];
        
    }
    return self;
}

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    
    parameters = parameters ?: @{};
    parameters = [parameters dictionaryByAddingDictionary:@{@"timeInForce": @"GTC", @"timestamp": @(timestamp), @"recvWindow": @5000}];
    NSString *queryString = EXQueryStringFromParameters(parameters, nil);
    NSString *signature = [queryString encodeHmacSHA384WithSceretKey:[self secretKey]];
    
    return [parameters dictionaryByAddingDictionary:@{@"signature": signature}];
}

@end

@implementation EXOKExHTTPClient

- (instancetype)initWithExchange:(EXExchange *)exchange{
    if (self =  [super initWithExchange:exchange]) {
        [[self requestSerializer] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

- (id)responseByFilterResponse:(id)response error:(NSError **)error{
    NSDictionary *result = [super responseByFilterResponse:response error:error];
    id status = result[@"result"];
    if (!status) return result;
    if ([status isEqual:@"true"] || [status boolValue]) return result;
    
    *error = [NSError errorWithDomain:EXExchangeOKExDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"网络请求失败"}];
    return result;
}

- (NSError *)transformError:(NSError *)error{
    NSUInteger code = [error code]; 
    NSString *description = EXOKExErrorDescription(code) ?: error.localizedDescription;
    
    return [NSError errorWithDomain:EXExchangeOKExDomain code:code userInfo:@{NSLocalizedDescriptionKey: ntoe(description)}];
}

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;{
    parameters = parameters ?: @{};
    if (!self.APIKey.length || !self.secretKey.length) {
        *error = [NSError errorWithDomain:EXExchangeOKExDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"请添加APIKey和SecretKey"}];
        return parameters;
    }
    
    parameters = [parameters dictionaryByAddingDictionary:@{@"api_key": [self APIKey]}];
    
    NSMutableArray *sortedKeys = [[parameters.allKeys sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    [sortedKeys addObject:@"secret_key"];
    NSDictionary *signParamters = [parameters dictionaryByAddingDictionary:@{@"secret_key": [self secretKey]}];
    
    NSString *queryString = EXQueryStringFromParameters(signParamters, sortedKeys);
    NSString *signature = [[queryString encodeMD5] uppercaseString];
    
    return [parameters dictionaryByAddingDictionary:@{@"sign": signature}];
}

@end

@implementation EXBitfinexHTTPClient

- (instancetype)initWithExchange:(EXExchange *)exchange{
    if (self =  [super initWithExchange:exchange]) {
        [[self requestSerializer] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [[self requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [[self requestSerializer] setValue:[self APIKey] forHTTPHeaderField:@"X-BFX-APIKEY"];
    }
    return self;
}

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;{
    parameters = parameters ?: @{};
    NSString *payload = [[parameters JSONData] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *signature = [payload encodeHmacSHA384WithSceretKey:[self secretKey]];
    [serializer setValue:payload forHTTPHeaderField:@"X-BFX-PAYLOAD"];
    [serializer setValue:signature forHTTPHeaderField:@"X-BFX-SIGNATURE"];
    
    return nil;
}

@end

@implementation EXHuobiHTTPClient

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;{
    NSParameterAssert(URLString);
//    HmacSHA256
//    按照ASCII码的顺序对参数名进行排序(使用 UTF-8 编码，且进行了 URI 编码，十六进制字符必须大写，如‘:’会被编码为'%3A'，空格被编码为'%20')
//    GET\n
//    api.huobi.pro\n
//    /v1/order/orders\n
//    AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2018-05-11T15%3A19%3A30&order-id=1234567890
//
//    AccessKeyId=e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx
//    &SignatureMethod=HmacSHA256
//    &SignatureVersion=2
//    &Timestamp=2018-05-11T15%3A19%3A30
    NSString *dateString = [[NSDate date] dateStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDictionary *requiredParameters = @{@"AccessKeyId":[self APIKey], @"SignatureMethod": @"HmacSHA256", @"SignatureVersion":@"2", @"Timestamp": dateString};
    
    parameters = parameters ?: @{};
    parameters = [parameters dictionaryByAddingDictionary:requiredParameters];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    NSArray<NSString *> *allKeys = [[parameters allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSString *queryString = EXQueryStringFromParameters(parameters, allKeys);
    NSString *commonString = fmts(@"%@\n%@\n%@\n%@", HTTPMethod, [[self baseURL] absoluteString], *URLString, queryString);
    NSString *signature  = [commonString encodeHmacSHA256WithSceretKey:[self secretKey]];
    
    return [parameters dictionaryByAddingDictionary:@{@"Signature": signature }];
}

@end

