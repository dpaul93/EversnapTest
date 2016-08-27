//
//  PhotoDetailsCollectionViewCell.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoDetailsCollectionViewCell.h"
#import "PhotoObject.h"
#import <UIImageView+AFNetworking.h>

@interface PhotoDetailsCollectionViewCell()

@property (weak, nonatomic) UIImageView *photoImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *titleView;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) NSLayoutConstraint *titleViewHeightConstraint;

@end

@implementation PhotoDetailsCollectionViewCell

#pragma mark - Initialization

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        self.photoImageView = imageView;
        
        UIView *titleView = [UIView new];
        titleView.backgroundColor = [[UIColor darkGrayColor ] colorWithAlphaComponent:0.5f];
        titleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:titleView];
        [titleView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [titleView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [titleView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        self.titleViewHeightConstraint = [titleView.heightAnchor constraintEqualToConstant:40.0f];
        self.titleViewHeightConstraint.active = YES;
        self.titleView = titleView;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        [self.titleView addSubview:titleLabel];
        [titleLabel.leftAnchor constraintEqualToAnchor:titleView.leftAnchor constant:5.0f].active = YES;
        [titleLabel.rightAnchor constraintEqualToAnchor:titleView.rightAnchor].active = YES;
        [titleLabel.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor].active = YES;
        self.titleLabelTopConstraint = [titleLabel.topAnchor constraintEqualToAnchor:titleView.topAnchor];
        self.titleLabelTopConstraint.active = YES;
        self.titleLabel = titleLabel;
        
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
    self.titleView.alpha = 0.0f;
    self.titleLabel.text = @"";
    self.photoImageView.image = nil;
}

#pragma mark - Setters

// Not really good practice to use external libraries in cell and call logic methods(violates SRP and coupling principles), but to make things prettier from view controller side, I moved this code here.
-(void)setPhotoObject:(PhotoObject *)photoObject {
    _photoObject = photoObject;
    self.titleLabel.text = photoObject.photoTitle;
    CGSize screen = [UIScreen mainScreen].bounds.size;
    CGRect rect = [self.titleLabel.text boundingRectWithSize:screen
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:self.titleLabel.font.pointSize] }
                                                       context:nil];
    self.titleViewHeightConstraint.constant = CGRectGetHeight(rect) + self.topViewOffset + 20.0f;
    
    [self.photoImageView cancelImageDownloadTask];
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoObject.photoURLLarge]];
    [self.photoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"photoCellPlaceholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.photoImageView.image = image;
        [self.activityIndicator stopAnimating];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
    }];
}

-(void)setTopViewOffset:(CGFloat)topViewOffset {
    _topViewOffset = topViewOffset;
    self.titleLabelTopConstraint.constant = topViewOffset;
}

-(void)setTitleViewHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat duration = animated ? 0.25f : 0.0f;
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    [UIView animateWithDuration:duration animations:^{
        self.titleView.alpha = alpha;
    }];
}

@end
