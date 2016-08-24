//
//  FlickrWebService.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "FlickrWebService.h"
#import <UIImageView+AFNetworking.h>

NSString * const kFlickrAPIKey = @"c472fb63bccdde81de67b841f1a00d70";

static NSString * const kBaseURL = @"https://api.flickr.com/services/";

@implementation FlickrWebService

#pragma mark - Overrides

+(NSString *)baseURL {
    return kBaseURL;
}

//-(Class)baseParseClass {
//    return [FlickrResponseInfo class];
//}

#pragma mark - Image loading

+(void)loadImageWithString:(NSString *)urlString forImageView:(UIImageView *)imageView {
    [imageView cancelImageDownloadTask];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    __weak typeof(imageView) __weakImageView = imageView;
    [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __weakImageView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
    }];
}

@end
