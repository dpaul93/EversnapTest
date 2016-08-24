//
//  BaseResponseInfo.m
//
//  Created by Paul Deynega on 2/9/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "BaseResponseInfo.h"

@implementation BaseResponseInfo

#pragma mark - Initialization

-(instancetype)initWithJSON:(id)json {
    NSAssert(YES, @"initWithJSON: should be overriden in child class.");
    return nil;
}

@end
