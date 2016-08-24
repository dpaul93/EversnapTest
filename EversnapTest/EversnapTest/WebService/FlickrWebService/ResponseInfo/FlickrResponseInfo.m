//
//  FlickrResponseInfo.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "FlickrResponseInfo.h"

@implementation FlickrResponseInfo

@dynamic parsedData;

#pragma mark - Initialization

-(instancetype)initWithJSON:(id)json {
    if(self = [super init]){
        self.responseData = json;
    }
    
    return self;
}

@end