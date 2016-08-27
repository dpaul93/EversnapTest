//
//  PhotoDetailsCollectionViewDataSource.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 25.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoDetailsCollectionViewDataSource.h"
#import "PhotoDetailsCollectionViewCell.h"
#import "PhotoDetailsHeaderReusableView.h"
#import "PhotoContainer.h"

@interface PhotoDetailsCollectionViewDataSource()

@property (assign, nonatomic, getter=isHeaderHidden, readwrite) BOOL headerHidden;
@property (assign, nonatomic, readwrite) NSInteger selectedIndex;

@end

@implementation PhotoDetailsCollectionViewDataSource

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoContainer.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoDetailsCollectionViewCell class]) forIndexPath:indexPath];
    cell.topViewOffset = self.headerViewSize.height;
    PhotoObject *photo = self.photoContainer.photos[indexPath.row];
    cell.photoObject = photo;
    
    [cell setTitleViewHidden:self.headerHidden animated:NO];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusable;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *identifier = NSStringFromClass([PhotoDetailsHeaderReusableView class]);
        PhotoDetailsHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        
        headerView.alpha = self.headerHidden ? 0.0f : 1.0f;
        
        NSInteger index = [self currentItemIndexFromScrollView:collectionView];
        headerView.titleLabel.text = [NSString stringWithFormat:@"%li of %lu", (long)index + 1, (unsigned long)self.photoContainer.photos.count];
        
        __weak typeof(self) _weakSelf = self;
        if(self.didTapBackButtonCallback) {
            headerView.didTapBackButtonCallback = ^(PhotoDetailsHeaderReusableView *view, UIButton *button) {
                _weakSelf.didTapBackButtonCallback(view, button);
            };
        }
        reusable = headerView;
    }
    return reusable;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.headerViewSize;
}

- (CGSize)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = theCollectionView.bounds.size;
    size.height -= self.headerViewSize.height;
    return theCollectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = [self currentItemIndexFromScrollView:scrollView];
    self.selectedIndex = index;
    
    PhotoDetailsHeaderReusableView *header = (PhotoDetailsHeaderReusableView*)[((UICollectionView*)scrollView) supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    header.titleLabel.text = [NSString stringWithFormat:@"%li of %lu", (long)index + 1, (unsigned long)self.photoContainer.photos.count];
}

#pragma mark - Header Methods

-(void)setHeaderHidden:(BOOL)hidden collectionView:(UICollectionView *)collectionView {
    self.headerHidden = hidden;
    PhotoDetailsHeaderReusableView *header = (PhotoDetailsHeaderReusableView*)[collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [header setHidden:hidden animated:YES];
    
    PhotoDetailsCollectionViewCell *cell = (PhotoDetailsCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self currentItemIndexFromScrollView:collectionView] inSection:0]];
    [cell setTitleViewHidden:hidden animated:YES];
}

#pragma mark - Getters

-(CGSize)contentSize {
    return (CGSize) {self.photoContainer.photos.count * self.itemSize.width, self.itemSize.height};
}

#pragma mark - Helpers

-(NSInteger)currentItemIndexFromScrollView:(UIScrollView*)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = offset.x / CGRectGetWidth(scrollView.bounds);
    return index;
}

@end
