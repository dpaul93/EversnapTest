//
//  PhotoDetailsCollectionViewCell.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoObject;

@interface PhotoDetailsCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) CGFloat topViewOffset;
@property (strong, nonatomic) PhotoObject *photoObject;

@property (copy, nonatomic) void (^didTapCellCallback)(PhotoDetailsCollectionViewCell *cell);

-(void)setTitleViewHidden:(BOOL)hidden animated:(BOOL)animated;

@end
