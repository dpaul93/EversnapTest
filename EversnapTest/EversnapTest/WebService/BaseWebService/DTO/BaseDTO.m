//
//  BaseDTO.m
//
//  Created by Paul Deynega on 2/9/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "BaseDTO.h"

@interface BaseDTO()

@property (nonatomic, strong) id parameters;

@end

@implementation BaseDTO

#pragma mark - Initialization

-(instancetype)initWithBlock:(void (^)(BaseDTO *))block {
    if(self = [self init]) {
        block(self);
    }
    
    return self;
}

-(instancetype)init {
    if(self = [super init]) {
        self.parseClass = NULL;
        self.parameters = [NSMutableDictionary new];
    }
    
    return self;
}

+(instancetype)initWithBlock:(void (^)(id))block {
    id dto = [[[self class] alloc] initWithBlock:block];
    return dto;
}

#pragma mark - Body Methods

-(void)addValue:(id)value key:(NSString *)key {
    if(!value || !key.length) {
        return;
    }
    [self.parameters setObject:value forKey:key];
}

-(void)setParametersExplicit:(id)parameters {
    self.parameters = parameters;
}

#pragma mark - Base DTO Methods

-(id)requestParameters {
    return self.parameters;
}

@end
