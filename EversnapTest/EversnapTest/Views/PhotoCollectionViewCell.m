//
//  PhotoCollectionViewCell.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell()

@property (weak, nonatomic, readwrite) UIImageView *photoImageView;
@property (weak, nonatomic, readwrite) UIActivityIndicatorView *activityIndicator;

@end

@implementation PhotoCollectionViewCell

#pragma mark - Initialization

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        [imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        self.photoImageView = imageView;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        activityIndicator.hidesWhenStopped = YES;
        [self addSubview:activityIndicator];
        [activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        self.activityIndicator = activityIndicator;
    }
    
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.photoImageView.image = nil;
    [self.activityIndicator stopAnimating];
}

@end
