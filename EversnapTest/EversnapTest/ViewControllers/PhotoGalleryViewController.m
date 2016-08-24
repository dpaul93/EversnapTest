//
//  PhotoGalleryViewController.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoContainer.h"
#import "PhotoObject.h"
#import "FlickrWebService.h"
#import "DTOWrapper.h"

#import <UIImage+AFNetworking.h>

@interface PhotoGalleryViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) PhotoContainer *photoContainer;

@end

@implementation PhotoGalleryViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Birthday";
    
    [self setupCollectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadPhotosWithPageIndex:0];
}

#pragma mark - Setup

-(void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
//    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class])];
    
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];

    [collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;

    self.photoCollectionView = collectionView;
}

#pragma mark - WebService

-(void)loadPhotosWithPageIndex:(NSInteger)page {
    BaseDTO *dto = [DTOWrapper getPhotosWithBirthdayTagPage:page];
    dto.parseClass = [PhotoContainer class];
    [FlickrWebService webServiceRequestWithDTO:dto completion:^(NSURLSessionDataTask *task, BaseResponseInfo<PhotoContainer*> *response) {
        if(response.parsedData) {
            
        } else {
            // Handle error
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

#pragma mark - UICollectionViewDelegate
#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - Setters

-(void)setPhotoContainer:(PhotoContainer *)photoContainer {
    if(_photoContainer) {
        _photoContainer = photoContainer;
    } else {
        [_photoContainer updateWithPhotoContainer:photoContainer];
    }
}
//URL:      https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a26f37cbaa4f90dcdcc9f70f9a92250b&tags=birthday&page=2&format=json&nojsoncallback=1&api_sig=0f31f71a93ad7c553c4a976cf410ec4f
//Request : https://api.flickr.com/services/rest/?api_key=c472fb63bccdde81de67b841f1a00d70&format=json&method=flickr.photos.search&page=0&tags=birthday

@end
