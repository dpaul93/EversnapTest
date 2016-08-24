//
//  PhotoContainer.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoContainer.h"
#import "PhotoObject.h"
#import "WebServiceConstants.h"

//page": 2, "pages": "2305", "perpage": 100, "total": "230401",

@implementation PhotoContainer

#pragma mark - Initialization

-(instancetype)initWithJSON:(id)json {
    if(self = [super init]) {
        NSDictionary *data = isNULL(json[@"photos"]);
        if(data) {
            self.page = [isNULL(data[@"page"]) integerValue];
            self.pages = [isNULL(data[@"pages"]) integerValue];
            self.perPage = [isNULL(data[@"perpage"]) integerValue];
            self.total = [isNULL(data[@"total"]) integerValue];
            NSArray *photos = isNULL(data[@"photos"]);
            NSMutableArray *temp = [NSMutableArray new];
            for (NSDictionary *photo in photos) {
                PhotoObject *model = [[PhotoObject alloc] initWithJSON:photo];
                [temp addObject:model];
            }
            self.photos = temp;
        }
    }
    
    return self;
}

@end
