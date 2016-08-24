//
//  WebServiceConstants.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "WebServiceConstants.h"

#pragma mark - Base Keys

NSString * const kUploadDataParameters = @"UploadDataParameters";

NSString * const kUploadDataData = @"UploadDataData";
NSString * const kUploadDataName = @"UploadDataName";
NSString * const kUploadDataFilename = @"UploadDataFilename";

#pragma mark - Functions

id isNULL(NSObject *object) {
    if([object isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return object;
    }
}

id isNil(NSObject *object) {
    if(!object) {
        return [NSNull class];
    } else {
        return object;
    }
}

@implementation WebServiceConstants

@end
