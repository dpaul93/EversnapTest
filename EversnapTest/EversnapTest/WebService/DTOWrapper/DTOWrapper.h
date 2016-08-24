//
//  DTOWrapper.h
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDTO.h"

@interface DTOWrapper : NSObject

+(BaseDTO*)getPhotosWithBirthdayTagPage:(NSInteger)page;

@end