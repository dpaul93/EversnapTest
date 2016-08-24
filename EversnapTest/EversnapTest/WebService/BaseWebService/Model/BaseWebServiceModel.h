//
//  BaseWebServiceModel.h
//
//  Created by Paul Deynega on 6/6/16.
//  Copyright © 2016 Migonsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseWebServiceModelInterface <NSObject>

@optional
-(instancetype)initWithJSON:(id)json;
-(void)updateWithJSON:(id)json;

@end

@interface BaseWebServiceModel : NSObject

@end
