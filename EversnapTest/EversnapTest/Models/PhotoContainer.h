//
//  PhotoContainer.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWebServiceModel.h"

@class PhotoObject;

@interface PhotoContainer : NSObject <BaseWebServiceModelInterface>

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger pages;
@property (assign, nonatomic) NSInteger perPage;
@property (assign, nonatomic) NSInteger total;

@property (strong, nonatomic) NSArray<PhotoObject*> *photos;

-(void)updateWithPhotoContainer:(PhotoContainer*)container;

@end
