//
//  WebServiceConstants.h
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BaseDTORequestType) {
    BaseDTORequestGET,
    BaseDTORequestPOST,
    BaseDTORequestPUT,
    BaseDTORequestDELETE
};

typedef NS_ENUM(NSInteger, BaseResponseInfoCode) {
    BaseResponseInfoCodeUnknown,
    BaseResponseInfoCode200 = 200,
    BaseResponseInfoCode400 = 400,
    BaseResponseInfoCode401 = 401,
    BaseResponseInfoCode404 = 404,
    BaseResponseInfoCode422 = 422,
    BaseResponseInfoCode500 = 500
};

typedef NS_ENUM(NSInteger, WebServiceUrl) {
    WebServiceUrlBeta,
    WebServiceUrlDev,
    WebServiceUrlLive
};

#pragma mark - Base Keys

extern NSString * const kUploadDataParameters;
extern NSString * const kUploadDataData;
extern NSString * const kUploadDataName;
extern NSString * const kUploadDataFilename;

#pragma mark - Functions

id isNULL(NSObject *object);
id isNil(NSObject *object);

@interface WebServiceConstants : NSObject

@end
