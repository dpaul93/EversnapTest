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
            NSArray *photos = isNULL(data[@"photo"]);
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

-(void)updateWithPhotoContainer:(PhotoContainer*)container {
    self.page = container.page;
    self.pages = container.pages;
    self.perPage = container.perPage;
    self.total = container.total;

    self.photos = [self.photos arrayByAddingObjectsFromArray:container.photos];
}

@end
