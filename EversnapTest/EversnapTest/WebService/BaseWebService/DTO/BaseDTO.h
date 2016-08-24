//
//  BaseDTO.h
//
//  Created by Paul Deynega on 2/9/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceConstants.h"

@interface BaseDTO : NSObject

@property (nonatomic, assign) BaseDTORequestType requestType;
@property (nonatomic, assign) Class parseClass;

@property (nonatomic, strong) NSString *urlEndpoint;
@property (nonatomic, strong) NSDictionary *headerFields;

+(instancetype)initWithBlock:(void (^) (id dto))block;

-(void)addValue:(id)value key:(NSString*)key;
-(void)setParametersExplicit:(id)parameters;

-(id)requestParameters;

@end
