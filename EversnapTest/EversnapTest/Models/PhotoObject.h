//
//  PhotoObject.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWebServiceModel.h"

@interface PhotoObject : NSObject <BaseWebServiceModelInterface>

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *photoOwner;
@property (strong, nonatomic) NSString *photoSecret;
@property (strong, nonatomic) NSString *photoServer;
@property (assign, nonatomic) NSInteger photoFarm;
@property (strong, nonatomic) NSString *photoTitle;
@property (assign, nonatomic) BOOL photoIsPublic;
@property (assign, nonatomic) BOOL photoIsFriend;
@property (assign, nonatomic) BOOL photoIsFamily;

@property (strong, nonatomic) NSString *photoURLSmall;
@property (strong, nonatomic) NSString *photoURLMedium;
@property (strong, nonatomic) NSString *photoURLLarge;

@end
