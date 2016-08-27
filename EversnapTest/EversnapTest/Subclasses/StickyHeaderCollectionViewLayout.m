//
//  StickyHeaderCollectionViewLayout.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 25.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "StickyHeaderCollectionViewLayout.h"
#import "PhotoDetailsCollectionViewDataSource.h"
#import "PhotoDetailsHeaderReusableView.h"
#import "CustomLayoutAttributes.h"

@interface StickyHeaderCollectionViewLayout()

@property (strong, nonatomic) NSMutableArray *cache;

@end

@implementation StickyHeaderCollectionViewLayout

-(CGSize)collectionViewContentSize {
    PhotoDetailsCollectionViewDataSource *dataSource = (PhotoDetailsCollectionViewDataSource*)self.collectionView.dataSource;
    return dataSource.contentSize;
}

-(void)prepareLayout {
    if(!self.cache.count) {
        NSMutableArray *cache = [NSMutableArray new];
        PhotoDetailsCollectionViewDataSource *dataSource = (PhotoDetailsCollectionViewDataSource*)self.collectionView.dataSource;
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
        for (NSInteger i = 0; i < numberOfItems; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CustomLayoutAttributes *att = [CustomLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            att.header = NO;
            att.frame = (CGRect){ CGPointMake(i * dataSource.itemSize.width, 0.0f), dataSource.itemSize };
            [cache addObject:att];
        }
        [cache addObject:[self reusableView]];
        self.cache = cache;
    } else {
        [self.cache removeLastObject];
        [self.cache addObject:[self reusableView]];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray new];
    for (CustomLayoutAttributes *att in self.cache) {
        if(CGRectIntersectsRect(rect, att.frame)) {
            [attributes addObject:att];
        }
    }
    
    return attributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(void)clearCache {
    [self.cache removeAllObjects];
}

-(UICollectionViewLayoutAttributes*)reusableView {
    CustomLayoutAttributes *header = [CustomLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    PhotoDetailsCollectionViewDataSource *dataSource = (PhotoDetailsCollectionViewDataSource*)self.collectionView.dataSource;
    header.frame = (CGRect) { self.collectionView.contentOffset, dataSource.headerViewSize };
    header.alpha = dataSource.isHeaderHidden ? 0.0f : 1.0f;
    header.header = YES;
    header.zIndex = 1024;
    return header;
}

@end
