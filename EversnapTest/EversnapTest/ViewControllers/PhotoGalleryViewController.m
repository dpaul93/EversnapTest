//
//  PhotoGalleryViewController.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoCollectionViewCell.h"
#import "LoadMoreCollectionReusableView.h"
#import "PhotoDetailsViewController.h"
#import "PhotoContainer.h"
#import "PhotoObject.h"
#import "FlickrWebService.h"
#import "DTOWrapper.h"

#import <UIImageView+AFNetworking.h>

CGFloat const kDefaultContentInset = 4.0f;

@interface PhotoGalleryViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) PhotoContainer *photoContainer;
@property (strong, nonatomic) NSMapTable *visibleSupplementaryViews;
@property (assign, nonatomic) CGSize cellSize;

@property (assign, nonatomic) BOOL requestInProgress;

@end

@implementation PhotoGalleryViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.visibleSupplementaryViews = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    
    self.navigationItem.title = @"Birthday";

    [self updateCellSizeFromScreenSize:self.view.bounds.size];
    [self setupCollectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.photoContainer.photos.count) {
        [self loadPhotosWithPageIndex:0 perPage:100];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self updateCellSizeFromScreenSize:size];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.photoCollectionView.collectionViewLayout invalidateLayout];
        [self.photoCollectionView layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

#pragma mark - Setup

-(void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.contentInset = UIEdgeInsetsMake(0.0f, kDefaultContentInset, kDefaultContentInset, kDefaultContentInset);
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class])];
    [collectionView registerClass:[LoadMoreCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([LoadMoreCollectionReusableView class])];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];

    [collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    
    collectionView.backgroundColor = [UIColor whiteColor];

    self.photoCollectionView = collectionView;
}

#pragma mark - WebService

-(void)loadPhotosWithPageIndex:(NSInteger)page perPage:(NSInteger)perPage {
    if(self.requestInProgress) {
        return;
    }
    self.requestInProgress = YES;
    BaseDTO *dto = [DTOWrapper getPhotosWithBirthdayTagPage:page perPage:perPage];
    dto.parseClass = [PhotoContainer class];
    [FlickrWebService webServiceRequestWithDTO:dto completion:^(NSURLSessionDataTask *task, BaseResponseInfo<PhotoContainer*> *response) {
        self.requestInProgress = NO;
        if(response.parsedData) {
            self.photoContainer = response.parsedData;
        } else if([response.responseData isKindOfClass:[NSError class]]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:((NSError*)response.responseData).localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Reload" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self loadPhotosWithPageIndex:page perPage:perPage];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoContainer.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell.activityIndicator startAnimating];
    PhotoObject *photo = self.photoContainer.photos[indexPath.row];
    [cell.photoImageView cancelImageDownloadTask];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photo.photoURLSmall]];
    [cell.photoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"photoCellPlaceholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [cell.activityIndicator stopAnimating];
        cell.photoImageView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.activityIndicator stopAnimating];
    }];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusable;
    
    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        NSString *identifier = NSStringFromClass([LoadMoreCollectionReusableView class]);
        LoadMoreCollectionReusableView *loadMoreView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
        CGFloat threshold = CGRectGetWidth(collectionView.bounds) > CGRectGetHeight(collectionView.bounds) ? 0.3f : 0.18f;
        loadMoreView.minFrameHeight = CGRectGetHeight(collectionView.bounds) * threshold;
        
        __weak typeof(self) _weakSelf = self;
        loadMoreView.loadCallback = ^(LoadMoreCollectionReusableView *reusable) {
            [_weakSelf loadNextPhotos];
        };
        [self.visibleSupplementaryViews setObject:loadMoreView forKey:identifier];
        reusable = loadMoreView;
    }
    return reusable;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailsViewController *photoDetailsViewController= [PhotoDetailsViewController new];
    photoDetailsViewController.photoContainer = self.photoContainer;
    photoDetailsViewController.selectedIndex = indexPath.row;
    [self.navigationController pushViewController:photoDetailsViewController animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0f, 0.1f);
}

- (CGSize)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kDefaultContentInset;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kDefaultContentInset;
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLoadMoreSizeWithScrollView:scrollView];
}

#pragma mark - Setters

-(void)setPhotoContainer:(PhotoContainer *)photoContainer {
    if(!photoContainer) {
        _photoContainer = nil;
        return;
    }
    
    if(!_photoContainer) {
        _photoContainer = photoContainer;
        [self.photoCollectionView reloadData];
    } else {
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (NSInteger i = 0, item = _photoContainer.photos.count; i < photoContainer.photos.count; i++, item++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:0]];
        }
        [_photoContainer updateWithPhotoContainer:photoContainer];
        [self.photoCollectionView insertItemsAtIndexPaths:indexPaths];
    }
}

#pragma mark - Helpers

-(void)updateCellSizeFromScreenSize:(CGSize)size {
    NSInteger rowCount = size.width > size.height ? 4 : 3;
    CGFloat cellSize = ((size.width - kDefaultContentInset * (rowCount + 1)) / rowCount);
    self.cellSize = CGSizeMake(cellSize, cellSize);
}

-(void)updateLoadMoreSizeWithScrollView:(UIScrollView*)scrollView {
    if(!self.photoContainer.photos.count) {
        return;
    }
    
    CGFloat yOffset = scrollView.contentSize.height - scrollView.contentOffset.y - CGRectGetHeight(scrollView.bounds);
    if(yOffset > 0.0f) {
        return;
    }
    CGSize size = CGSizeMake(CGRectGetWidth(scrollView.bounds), fabs(yOffset));
    UICollectionReusableView *reusable = [self.visibleSupplementaryViews objectForKey:NSStringFromClass([LoadMoreCollectionReusableView class])];
    if(reusable) {
        CGRect frame = reusable.frame;
        frame.size = size;
        [reusable setFrame:frame];
    }
}

-(void)loadNextPhotos {
    if(self.photoContainer.page < self.photoContainer.pages) {
        [self loadPhotosWithPageIndex:self.photoContainer.page + 1 perPage:50];
    }
}

@end
