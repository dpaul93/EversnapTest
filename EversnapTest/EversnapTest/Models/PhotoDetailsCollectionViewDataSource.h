//
//  PhotoDetailsCollectionViewDataSource.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 25.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoContainer, PhotoDetailsHeaderReusableView;

@interface PhotoDetailsCollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) PhotoContainer *photoContainer;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGSize headerViewSize;

@property (copy, nonatomic) void (^didTapBackButtonCallback)(PhotoDetailsHeaderReusableView *reusable, UIButton *button);

@property (assign, nonatomic, readonly) CGSize contentSize;
@property (assign, nonatomic, getter=isHeaderHidden, readonly) BOOL headerHidden;
@property (assign, nonatomic, readonly) NSInteger selectedIndex;

-(void)setHeaderHidden:(BOOL)hidden collectionView:(UICollectionView*)collectionView;

@end
