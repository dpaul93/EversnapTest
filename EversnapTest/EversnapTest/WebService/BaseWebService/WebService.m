//
//  WebService.m
//
//  Created by Paul Deynega on 2/8/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "AppDelegate.h"

#import "WebService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <objc/runtime.h>

@implementation WebService

#pragma mark - Initialization

-(instancetype)init {
    NSURL *base = [NSURL URLWithString:[[self class] baseURL]];
    
    if(self = [super initWithBaseURL:base sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

-(void)dealloc {
    WebLog(@"%@ %@ was deallocated.", NSStringFromClass([self class]), self.description);
}

#pragma mark - Overriden Behavior

-(NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error))completionHandler {
    [self printDataFromRequest:request];
    return [super dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        completionHandler(response, responseObject, responseObject);
    }];
}

-(NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgressBlock downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    [self printDataFromRequest:request];
    return [super dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
}

-(NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request progress:(void (^)(NSProgress * _Nonnull))uploadProgressBlock completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
    [self printDataFromRequest:request];
    return [super uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:completionHandler];
}

#pragma mark - Request Methods

-(void)requestWithDTO:(BaseDTO *)dto completion:(void (^)(NSURLSessionDataTask *, id))completion {
    if(dto) {
        baseCompletionBlock baseCompletion = [self baseRequestCompletionBlockWithParseClass:dto.parseClass completion:completion];
        
        [self populateObject:self.requestSerializer withDTO:dto];
        
        switch (dto.requestType) {
            case BaseDTORequestGET:
                [self GET:dto.urlEndpoint parameters:dto.requestParameters progress:nil success:baseCompletion failure:baseCompletion]; break;
            case BaseDTORequestPOST:
                [self POST:dto.urlEndpoint parameters:dto.requestParameters progress:nil success:baseCompletion failure:baseCompletion]; break;
            case BaseDTORequestPUT:
                [self PUT:dto.urlEndpoint parameters:dto.requestParameters success:baseCompletion failure:baseCompletion]; break;
            case BaseDTORequestDELETE:
                [self DELETE:dto.urlEndpoint parameters:dto.requestParameters success:baseCompletion failure:baseCompletion]; break;
            default: break;
        }
    }
}

-(NSURLSessionUploadTask*)uploadDataWithDTO:(BaseDTO*)dto progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(baseCompletionBlock)completion {
    NSString *url = [self.baseURL.absoluteString stringByAppendingString:dto.urlEndpoint];
    NSDictionary *parameters = [dto.requestParameters objectForKey:kUploadDataParameters];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {        
        NSDictionary *requestParameters = dto.requestParameters;
        NSData *fileData = [requestParameters objectForKey:kUploadDataData];
        NSString *name = [requestParameters objectForKey:kUploadDataName];
        NSString *filename = [requestParameters objectForKey:kUploadDataFilename];
        
        [formData appendPartWithFileData:fileData name:name fileName:filename mimeType:@"multipart/form-data"];
    } error:nil];
        
    [self populateObject:request withDTO:dto];
    
    baseCompletionBlock baseCompletion = [self baseRequestCompletionBlockWithParseClass:dto.parseClass completion:completion];
    
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        baseCompletion(uploadTask, responseObject);
    }];
    
    [uploadTask resume];
    
    return uploadTask;
}

#pragma mark - Cancel

-(void)cancelAllTasks {
    [self.operationQueue cancelAllOperations];
}

#pragma mark - Helpers

-(void)printDataFromRequest:(NSURLRequest*)request {
    NSString *httpHeaders = @"";
    for (NSString *key in request.allHTTPHeaderFields.allKeys) {
        NSString *value = [NSString stringWithFormat:@"%@ : %@\n", key, request.allHTTPHeaderFields[key]];
        httpHeaders = [httpHeaders stringByAppendingString:value];
    }
    
    NSError *error;
    NSDictionary *body = [NSDictionary new];
    if (request.HTTPBody) {
        body = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:&error];
    }
    WebLog(@"----------\nRequest: %@ %@\nHTTP Headers:\n%@ \nSent body:\n%@\n----------\n", request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields, body);
}

-(baseCompletionBlock)baseRequestCompletionBlockWithParseClass:(Class)parseClass completion:(baseCompletionBlock)completion {
    if(!completion) {
        return nil;
    }
    
    baseCompletionBlock baseCompletion = ^void(NSURLSessionDataTask * task, id response) {
        NSArray *dataTasks = self.dataTasks;
        if(!dataTasks.count) {
            [self invalidateSessionCancelingTasks:YES];
        }
        
        id responseInfo;
        if(self.parseCompletionBlock) {
            responseInfo = self.parseCompletionBlock(task, response);
        } else {
            responseInfo = [self responseObjectWithTask:task reponse:response parseClass:parseClass];
        }
        if([self shouldInvokeCompletionWithObject:responseInfo]) {
            completion(task, responseInfo);
        }
    };
    return baseCompletion;
}

-(id)parsedResponseWithResponseData:(id)data parseClass:(Class)parseClass {
    if([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *element in data) {
            id object = [[parseClass alloc] initWithJSON:element];
            [temp addObject:object];
        }
        return temp;
    } else if([data isKindOfClass:[NSDictionary class]]) {
        id parsedData = [[parseClass alloc] initWithJSON:data];
        return parsedData;
    }
    return data;
}

-(void)populateObject:(id)object withDTO:(BaseDTO*)dto {
    if(![object respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
        return;
    }

    for (NSString *key in dto.headerFields.allKeys) {
        NSString *value = dto.headerFields[key];
        [object setValue:value forHTTPHeaderField:key];
    }
}

+(WebService *)webServiceRequestWithDTO:(BaseDTO *)dto completion:(void (^)(NSURLSessionDataTask *, id))completion {
    WebService *service = [[self class] new];
    [service requestWithDTO:dto completion:completion];
    return service;
}

+(WebService *)webServiceUploadRequestWithDTO:(BaseDTO *)dto progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(void (^)(NSURLSessionDataTask *, id))completion {
    WebService *service = [[self class] new];
    [service uploadDataWithDTO:dto progress:uploadProgressBlock completion:completion];
    return service;
}

#pragma mark - Basic overrides

-(id)responseObjectWithTask:(NSURLSessionDataTask *)task reponse:(id)response parseClass:(Class)parseClass {
    BaseResponseInfo *responseInfo;
    if([response isKindOfClass:[NSDictionary class]]) {
        
        WebLog(@"----------\nRequest : %@\nReceived BODY : %@\n----------", task.response.URL.description, [response description]);
        
        if([[parseClass new] isKindOfClass:[self baseParseClass]]) {
            if([parseClass instancesRespondToSelector:@selector(initWithJSON:)]) {
                responseInfo = [[parseClass alloc] initWithJSON:response];
            }
        } else {
            responseInfo = [[[self baseParseClass] alloc] initWithJSON:response];
            if([parseClass instancesRespondToSelector:@selector(initWithJSON:)]) {
                responseInfo.parsedData = [self parsedResponseWithResponseData:responseInfo.responseData parseClass:parseClass];
            } else {
                responseInfo.parsedData = responseInfo.responseData;
            }
        }
        
        if(!responseInfo) {
            responseInfo = response;
        }
    } else if ([response isKindOfClass:[NSError class]]) {
        NSError *error = response;
        
        WebLog(@"Received ERROR : %@\nRequest : %@", [error localizedDescription], task.response.URL.description);
        
        responseInfo = [[self baseParseClass] new];
        responseInfo.responseData = error;
    }
    
    return responseInfo;
}

-(BOOL)shouldInvokeCompletionWithObject:(BaseResponseInfo *)object {
    return YES;
}

+(NSString *)baseURL {
    NSAssert(YES, @"Should be overriden!");
    return nil;
}

-(Class)baseParseClass {
    return [BaseResponseInfo class];
}

@end
