//
//  PhotoCollectionViewCell.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic, readonly) UIImageView *photoImageView;
@property (weak, nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

@end
