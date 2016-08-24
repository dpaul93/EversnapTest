//
//  PhotoObject.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoObject.h"
#import "WebServiceConstants.h"

//{ "id": "29083721782", "owner": "12328243@N02", "secret": "974dc8c399", "server": "8277", "farm": 9, "title": "P1070314", "ispublic": 1, "isfriend": 0, "isfamily": 0 },

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

/*
 small square 75x75
 q	large square 150x150
 t	thumbnail, 100 on longest side
 m	small, 240 on longest side
 n	small, 320 on longest side
 -	medium, 500 on longest side
 z	medium 640, 640 on longest side
 c	medium 800, 800 on longest side†
 b	large, 1024 on longest side*
 h	large 1600, 1600 on longest side†
 k	large 2048, 2048 on longest side†
 o	original image, either a jpg, gif or png, depending on source format
 
 */
//https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
//
//farm-id: 1
//server-id: 2
//photo-id: 1418878
//secret: 1e92283336
//size: m


@end
