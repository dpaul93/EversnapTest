//
//  BaseResponseInfo.h
//
//  Created by Paul Deynega on 2/9/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceConstants.h"
#import "BaseWebServiceModel.h"

@interface BaseResponseInfo <__covariant ObjectType> : NSObject <BaseWebServiceModelInterface>

@property (nonatomic, assign) id responseData;
@property (nonatomic, strong) ObjectType parsedData;

@end
