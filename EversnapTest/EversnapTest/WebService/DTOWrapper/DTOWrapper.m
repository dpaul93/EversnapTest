//
//  DTOWrapper.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "DTOWrapper.h"
#import "BaseDTO.h"
#import "WebService.h"

NSString * const kFlickrAPIKey = @"c472fb63bccdde81de67b841f1a00d70";

@implementation DTOWrapper

+(BaseDTO *)getPhotosWithBirthdayTagPage:(NSInteger)page perPage:(NSInteger)perPage {
    BaseDTO *baseDTO = [BaseDTO initWithBlock:^(BaseDTO *dto) {
        dto.requestType = BaseDTORequestGET;
        dto.urlEndpoint = @"rest/";
        
        [dto addValue:@"flickr.photos.search" key:@"method"];
        [dto addValue:kFlickrAPIKey key:@"api_key"];
        [dto addValue:@"birthday" key:@"tags"];
        [dto addValue:@(page) key:@"page"];
        [dto addValue:@"json" key:@"format"];
        [dto addValue:@(1) key:@"nojsoncallback"];
        [dto addValue:@(perPage) key:@"per_page"];
    }];
    
    return baseDTO;
}

@end
