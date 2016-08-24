//
//  WebService.h
//
//  Created by Paul Deynega on 2/8/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BaseDTO.h"
#import "BaseResponseInfo.h"

#define WEBLOGS_ENABLED YES
#define WebLog(FORMAT, ...) if(WEBLOGS_ENABLED) { printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]); }

typedef void (^baseCompletionBlock)(NSURLSessionDataTask *, id);

@interface WebService : AFHTTPSessionManager

@property (copy, nonatomic) id (^parseCompletionBlock)(NSURLSessionDataTask *, id);

-(void)requestWithDTO:(BaseDTO*)dto completion:(baseCompletionBlock)completion;
-(NSURLSessionUploadTask*)uploadDataWithDTO:(BaseDTO*)dto progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(baseCompletionBlock)completion;
-(void)cancelAllTasks;

-(Class)baseParseClass;
-(id)responseObjectWithTask:(NSURLSessionDataTask*)task reponse:(id)response parseClass:(Class)parseClass;
-(BOOL)shouldInvokeCompletionWithObject:(BaseResponseInfo*)object;

+(WebService*)webServiceRequestWithDTO:(BaseDTO*)dto completion:(baseCompletionBlock)completion;
+(WebService*)webServiceUploadRequestWithDTO:(BaseDTO *)dto progress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock completion:(baseCompletionBlock)completion;

+(NSString*)baseURL;

@end
