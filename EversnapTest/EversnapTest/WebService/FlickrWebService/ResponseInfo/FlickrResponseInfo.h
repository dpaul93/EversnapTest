//
//  FlickrResponseInfo.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 23.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "BaseResponseInfo.h"

@interface FlickrResponseInfo <__covariant ObjectType> : BaseResponseInfo

@property (nonatomic, strong) ObjectType parsedData;

@end
