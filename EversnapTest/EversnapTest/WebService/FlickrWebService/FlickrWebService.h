//
//  FlickrWebService.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "WebService.h"
#import "FlickrDTO.h"
#import "FlickrResponseInfo.h"

NSString * const kFlickrAPIKey;

@interface FlickrWebService : WebService

+(void)loadImageWithString:(NSString *)urlString forImageView:(UIImageView *)imageView;

@end
