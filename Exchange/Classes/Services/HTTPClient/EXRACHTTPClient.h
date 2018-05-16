//
//  EXRACHTTPClient.h
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class RACSignal;
@interface EXRACHTTPClient : AFHTTPSessionManager

- (id)responseByFilterResponse:(id)response error:(NSError **)error;

- (NSError *)transformError:(NSError *)error;

- (NSError *)errorWithTask:(NSURLSessionDataTask *)task error:(NSError *)error;

- (NSDictionary *)parametersWithURLString:(NSString **)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters serializer:(AFHTTPRequestSerializer *)serializer error:(NSError **)error;

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress;
- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath progress:(void (^)(NSProgress *progress))progress;

- (RACSignal *)HEAD:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)HEAD:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))progress;
- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath progress:(void (^)(NSProgress *uploadProgress))progress;

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;
- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress;
- (RACSignal *)POST:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress;

- (RACSignal *)PUT:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)PUT:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

- (RACSignal *)PATCH:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)PATCH:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

- (RACSignal *)DELETE:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)DELETE:(NSString *)URLString parameters:(id)parameters resultClass:(Class)resultClass keyPath:(NSString *)keyPath;

@end
