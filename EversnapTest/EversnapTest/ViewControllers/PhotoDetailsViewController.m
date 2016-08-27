//
//  PhotoDetailsViewController.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "PhotoDetailsCollectionViewCell.h"
#import "PhotoDetailsHeaderReusableView.h"
#import "StickyHeaderCollectionViewLayout.h"
#import "PhotoDetailsCollectionViewDataSource.h"
#import "PhotoContainer.h"

static NSInteger const kHeaderHeight = 64.0f;

@interface PhotoDetailsViewController() <UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) PhotoDetailsCollectionViewDataSource *dataSource;

@end

@implementation PhotoDetailsViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.dataSource = [PhotoDetailsCollectionViewDataSource new];
    self.dataSource.itemSize = (CGSize) { CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) };
    self.dataSource.photoContainer = self.photoContainer;
    self.dataSource.headerViewSize = CGSizeMake(CGRectGetWidth(self.view.bounds), kHeaderHeight);
    __weak typeof(self) _weakSelf = self;
    self.dataSource.didTapBackButtonCallback = ^(PhotoDetailsHeaderReusableView *view, UIButton *button) {
        [_weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self setupCollectionView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidTap:)];
    [self.photoCollectionView addGestureRecognizer:tapRecognizer];
    
    [self.dataSource addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.selectedIndex) {
        [self.photoCollectionView setNeedsLayout];
        [self.photoCollectionView layoutIfNeeded];
        CGRect scrollPosition = (CGRect) { CGPointMake(self.selectedIndex * self.dataSource.itemSize.width, 0.0f), self.dataSource.itemSize };
        [self.photoCollectionView scrollRectToVisible:scrollPosition animated:NO];
    }
}

-(void)dealloc {
    [self.dataSource removeObserver:self forKeyPath:@"selectedIndex"];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [((StickyHeaderCollectionViewLayout*)self.photoCollectionView.collectionViewLayout) clearCache];
    self.dataSource.itemSize = size;
    self.dataSource.headerViewSize = CGSizeMake(size.width, kHeaderHeight);
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.photoCollectionView.collectionViewLayout invalidateLayout];
        [self.photoCollectionView layoutIfNeeded];
        CGRect visibleRect = (CGRect) { CGPointMake(self.selectedIndex * size.width, 0.0f), size };
        [self.photoCollectionView scrollRectToVisible:visibleRect animated:NO];
    } completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setupCollectionView {
    StickyHeaderCollectionViewLayout *flowLayout = [StickyHeaderCollectionViewLayout new];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsZero;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView registerClass:[PhotoDetailsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoDetailsCollectionViewCell class])];
    [collectionView registerClass:[PhotoDetailsHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PhotoDetailsHeaderReusableView class])];
    
    collectionView.delegate = self.dataSource;
    collectionView.dataSource = self.dataSource;
    
    [self.view addSubview:collectionView];
    
    [collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    
    collectionView.backgroundColor = [UIColor blackColor];
    
    self.photoCollectionView = collectionView;
}

#pragma mark - Gesture Handling

-(void)gestureRecognizerDidTap:(UITapGestureRecognizer*)tapRecognizer {
    [self.dataSource setHeaderHidden:!self.dataSource.isHeaderHidden collectionView:self.photoCollectionView];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"selectedIndex"]) {
        NSInteger index = [change[NSKeyValueChangeNewKey] integerValue];
        self.selectedIndex = index;
    }
}

@end
