//
//  EXRACHTTPClient.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "EXRACHTTPClient.h"
#import "EXModel.h"

NSString * const MDHTTPMethodGET        = @"GET";

NSString * const MDHTTPMethodPOST       = @"POST";

NSString * const MDHTTPMethodPUT        = @"PUT";

NSString * const MDHTTPMethodDELETE     = @"DELETE";

NSString * const MDHTTPMethodHEAD       = @"HEAD";

NSString * const MDHTTPMethodPATCH      = @"PATCH";

NSString * const MDReactiveCocoaHTTPClientAuthorizeURLString = @"validateMachineNumber";

@implementation EXRACHTTPClient

- (id)initWithURL:(NSURL *)URL {
    NSParameterAssert(URL != nil);
    self = [self initWithBaseURL:URL];
    if (self) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    }
    return self;
}

- (id)responseByFilterResponse:(id)response error:(NSError **)error{
    if ([response isKindOfClass:[NSArray class]] || [response isKindOfClass:[NSDictionary class]]) {
        response =  [response filterNullObject];
    }
    return response;
}

- (NSError *)transformError:(NSError *)error;{
    return error;
}

- (NSError *)errorWithTask:(NSURLSessionDataTask *)task error:(NSError *)error{
    return error;
}

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;{
    return parameters;
}

- (RACSignal *)POST:(NSString *)URLString
         parameters:(id)parameters
        resultClass:(Class)resultClass
            keyPath:(NSString *)keyPath
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
           progress:(void (^)(NSProgress *))uploadProgress{
    @weakify(self);
    RACSignal *signal = [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSError *error = nil;
        NSString *validURLString = URLString;
        NSDictionary *validParameters = [self parametersWithURLString:&validURLString HTTPMethod:@"POST" parameters:parameters serializer:[self requestSerializer] error:&error];
        if (error) return [[RACSignal error:error] subscribe:subscriber];
        
        NSString *URLAbsoluteString = [[NSURL URLWithString:validURLString relativeToURL:self.baseURL] absoluteString];
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLAbsoluteString parameters:validParameters constructingBodyWithBlock:block error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:[self errorWithTask:nil error:serializationError]];
            });
#pragma clang diagnostic pop
            return nil;
        }
        __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            @strongify(self);
            if (error) {
                [subscriber sendError:[self errorWithTask:task error:error]];
            } else {
                NSError *error = nil;
                responseObject = [self responseByFilterResponse:responseObject error:&error];
                
                if (!error) [[RACSignal return:responseObject] subscribe:subscriber];
                else [[RACSignal error:error] subscribe:subscriber];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] map:^id(id value) {
        @strongify(self);
        if (resultClass || keyPath) return [self parsedResponseOfClass:resultClass keyPath:keyPath fromJSON:value];
        else return value;
    }] concat] catch:^RACSignal *(NSError *error) {
        @strongify(self);
        return [RACSignal error:[self transformError:error]];
    }];
    
#if DEBUG
    return [[signal logNext] logError];
#else
    return signal;
#endif
}

- (RACSignal *)dataTaskWithHTTPMethod:(NSString *)method
                            URLString:(NSString *)URLString
                           parameters:(id)parameters
                          resultClass:(Class)resultClass
                              keyPath:(NSString *)keyPath
                       uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                     downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress{
    @weakify(self);
    RACSignal *signal = [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSError *error = nil;
        NSString *validURLString = URLString;
        NSDictionary *validParameters = [self parametersWithURLString:&validURLString HTTPMethod:@"POST" parameters:parameters serializer:[self requestSerializer] error:&error];
        if (error) return [[RACSignal error:error] subscribe:subscriber];
        
        NSError *serializationError = nil;
        NSString *URLAbsoluteString = [[NSURL URLWithString:validURLString relativeToURL:self.baseURL] absoluteString];
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:URLAbsoluteString parameters:validParameters error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:[self errorWithTask:nil error:serializationError]];
            });
#pragma clang diagnostic pop
            return nil;
        }
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:[self errorWithTask:task error:error]];
            } else {
                NSError *error = nil;
                responseObject = [self responseByFilterResponse:responseObject error:&error];
                if (!error) [[RACSignal return:responseObject] subscribe:subscriber];
                else [[RACSignal error:error] subscribe:subscriber];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] map:^id(id value) {
        @strongify(self);
        if (resultClass || keyPath) return [self parsedResponseOfClass:resultClass keyPath:keyPath fromJSON:value];
        else return [RACSignal return:value];
    }] concat] catch:^RACSignal *(NSError *error) {
        @strongify(self);
        return [RACSignal error:[self transformError:error]];
    }];
#if DEBUG
    return [[signal logNext] logError];
#else
    return signal;
#endif
}

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters;{
    return [self GET:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self GET:URLString parameters:parameters resultClass:resultClass keyPath:keyPath progress:nil];
}

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress;{
    return [self GET:URLString parameters:parameters resultClass:nil keyPath:nil progress:progress];
}

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath progress:(void (^)(NSProgress *progress))progress;{
    return [self dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:nil downloadProgress:progress];
}

- (RACSignal *)HEAD:(NSString *)URLString parameters:(id)parameters;{
    return [self HEAD:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)HEAD:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self dataTaskWithHTTPMethod:@"HEAD" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:nil downloadProgress:nil];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters;{
    return [self POST:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self POST:URLString parameters:parameters resultClass:resultClass keyPath:keyPath progress:nil];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))progress;{
    return [self POST:URLString parameters:parameters resultClass:nil keyPath:nil progress:progress];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath progress:(void (^)(NSProgress *uploadProgress))progress;{
    return [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:progress downloadProgress:nil];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;{
    return [self POST:URLString parameters:parameters resultClass:nil keyPath:nil constructingBodyWithBlock:block];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;{
    return [self POST:URLString parameters:parameters resultClass:resultClass keyPath:keyPath constructingBodyWithBlock:block progress:nil];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress;{
    return [self POST:URLString parameters:parameters resultClass:nil keyPath:nil constructingBodyWithBlock:block progress:progress];
}

- (RACSignal *)PUT:(NSString *)URLString parameters:(id)parameters;{
    return [self PUT:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)PUT:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self dataTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:nil downloadProgress:nil];
}

- (RACSignal *)PATCH:(NSString *)URLString parameters:(id)parameters;{
    return [self PATCH:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)PATCH:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self dataTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:nil downloadProgress:nil];
}

- (RACSignal *)DELETE:(NSString *)URLString parameters:(id)parameters;{
    return [self DELETE:URLString parameters:parameters resultClass:nil keyPath:nil];
}

- (RACSignal *)DELETE:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;{
    return [self dataTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters resultClass:resultClass keyPath:keyPath uploadProgress:nil downloadProgress:nil];
}

- (NSString *)stringValueFromFromJSONObject:(id)JSONObject{
    if ([JSONObject isKindOfClass:[NSDictionary class]] || [JSONObject isKindOfClass:[NSArray class]]) {
        return [JSONObject JSONString];
    } else if ([JSONObject isKindOfClass:[NSNumber class]]) {
        return [JSONObject stringValue];
    } else if ([JSONObject isKindOfClass:[NSString class]]) {
        return JSONObject;
    } else {
        return [JSONObject description];
    }
}

- (NSDate *)dateValueFromJSONObject:(id)JSONObject{
    if ([JSONObject isKindOfClass:[NSDate class]]) return JSONObject;
    if ([JSONObject isKindOfClass:[NSNumber class]]) return [NSDate dateWithTimeIntervalSince1970:[JSONObject doubleValue]];
    if ([JSONObject isKindOfClass:[NSString class]]) return [NSDate dateWithTimeIntervalSince1970:[JSONObject doubleValue]];
    return nil;
}

- (NSURL *)URLValueFromJSONObject:(id)JSONObject{
    if ([JSONObject isKindOfClass:[NSURL class]]) return JSONObject;
    if ([JSONObject isKindOfClass:[NSString class]]) return [NSURL URLWithString:JSONObject];
    
    return nil;
}

- (NSDictionary *)dictionaryValueFromJSONObject:(id)JSONObject{
    if ([JSONObject isKindOfClass:[NSDictionary class]]) return JSONObject;
    if ([JSONObject isKindOfClass:[NSString class]]) return [JSONObject objectFromJSONString];
    if ([JSONObject isKindOfClass:[NSData class]]) return [JSONObject objectFromJSONData];
    return nil;
}

- (RACSignal *)parsedResponseOfClass:(Class)resultClass keyPath:(NSString *)keyPath fromJSON:(id)responseObject {
    //    NSParameterAssert(resultClass == nil || [resultClass isSubclassOfClass:[MTLModel class]]);
    @weakify(self);
    return [RACSignal createSignal:^ id (id<RACSubscriber> subscriber) {
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            @strongify(self);
            void (^adapteJOSNModel)(NSDictionary *JSONValue) = ^(NSDictionary *JSONValue){
                NSError *error = nil;
                id parsedObject = [JSONValue modelOfClass:resultClass error:&error];
                if (parsedObject == nil) {
                    // Don't treat "no class found" errors as real parsing failures.
                    // In theory, this makes parsing code forward-compatible with
                    // API additions.
                    if (error) {
                        NSLog(@"Parsed model failed : %@   \n JOSN : %@", error, responseObject);
                        [subscriber sendError:error];
                    }
                    return;
                }
                [subscriber sendNext:parsedObject];
            };
            id JSONValue = JSONDictionary;
            if ([JSONValue isKindOfClass:[NSDictionary class]] && [keyPath length]) {
                JSONValue = [JSONDictionary valueForKeyPath:keyPath];
            }
            if (resultClass == nil) {
                [subscriber sendNext:JSONValue];
                return;
            }
            if (![JSONValue isKindOfClass:[NSArray class]]) {
                if (resultClass == [NSString class]) {
                    [subscriber sendNext:[self stringValueFromFromJSONObject:JSONValue]];
                } else if (resultClass == [NSNumber class]) {
                    [subscriber sendNext:[[NSNumberFormatter new] numberFromString:[self stringValueFromFromJSONObject:JSONValue]]];
                } else if (resultClass == [NSDate class]) {
                    [subscriber sendNext:[self dateValueFromJSONObject:JSONValue]];
                } else if (resultClass == [NSURL class]) {
                    [subscriber sendNext:[self URLValueFromJSONObject:JSONValue]];
                } else if (resultClass == [NSDictionary class]) {
                    [subscriber sendNext:[self dictionaryValueFromJSONObject:JSONValue]];
                } else {
                    adapteJOSNModel(JSONValue);
                }
            } else {
                for (NSDictionary *subJSONValue in JSONValue) {
                    if (![subJSONValue isKindOfClass:[NSDictionary class]]) {
                        [subscriber sendNext:JSONValue];
                        return ;
                    }
                    adapteJOSNModel(subJSONValue);
                }
            }
        };
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *JSONDictionary in responseObject) {
                if (![JSONDictionary isKindOfClass:[NSDictionary class]]) {
                    [subscriber sendNext:responseObject];
                    return nil;
                }
                parseJSONDictionary(JSONDictionary);
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            parseJSONDictionary(responseObject);
            [subscriber sendCompleted];
        } else {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

@end
