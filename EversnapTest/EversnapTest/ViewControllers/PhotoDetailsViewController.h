//
//  PhotoDetailsViewController.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoContainer;

@interface PhotoDetailsViewController : UIViewController

@property (strong, nonatomic) PhotoContainer *photoContainer;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
