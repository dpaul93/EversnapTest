//
//  PhotoObject.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoObject.h"
#import "WebServiceConstants.h"

@implementation PhotoObject

#pragma mark - Initialization

-(instancetype)initWithJSON:(id)json {
    if(self = [super init]) {
        self.photoID = isNULL(json[@"id"]);
        self.photoOwner = isNULL(json[@"owner"]);
        self.photoSecret = isNULL(json[@"secret"]);
        self.photoServer = isNULL(json[@"server"]);
        self.photoTitle = isNULL(json[@"title"]);
        self.photoFarm = [isNULL(json[@"farm"]) integerValue];
        self.photoIsPublic = [isNULL(json[@"ispublic"]) integerValue];
        self.photoIsFriend = [isNULL(json[@"isfriend"]) integerValue];
        self.photoIsFamily = [isNULL(json[@"isfamily"]) integerValue];
    }
    
    return self;
}

#pragma mark - Getters

-(NSString *)photoURLSmall {
    return [self photoURLWithSize:@"n"];
}

-(NSString *)photoURLMedium {
    return [self photoURLWithSize:@"c"];
}

-(NSString *)photoURLLarge {
    return [self photoURLWithSize:@"b"];
}

#pragma mark - Helpers

-(NSString*)photoURLWithSize:(NSString*)size {
    return [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_%@.jpg", (long)self.photoFarm, self.photoServer, self.photoID, self.photoSecret, size];
}

@end
