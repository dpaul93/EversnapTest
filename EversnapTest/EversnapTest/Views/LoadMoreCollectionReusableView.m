//
//  LoadMoreCollectionReusableView.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "LoadMoreCollectionReusableView.h"

@interface LoadMoreCollectionReusableView()

@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) UILabel *loadMoreLabel;


@property (assign, nonatomic) BOOL shouldCallCallback;

@end

@implementation LoadMoreCollectionReusableView

#pragma mark - Initialization

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:activityIndicator];
        [activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        self.activityIndicator = activityIndicator;
        
        UILabel *loadMoreLabel = [UILabel new];
        loadMoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
        loadMoreLabel.textAlignment = NSTextAlignmentCenter;
        loadMoreLabel.clipsToBounds = YES;
        loadMoreLabel.text = @"pull to load more";
        [self addSubview:loadMoreLabel];
        [loadMoreLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [loadMoreLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [loadMoreLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [loadMoreLabel.topAnchor constraintEqualToAnchor:activityIndicator.bottomAnchor].active = YES;
        self.loadMoreLabel = loadMoreLabel;
    }
    
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.shouldCallCallback = NO;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if(CGRectGetHeight(frame) > self.minFrameHeight) {
        self.shouldCallCallback = YES;
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    if(CGRectGetHeight(frame) <= 10.0f && self.shouldCallCallback) {
        self.shouldCallCallback = NO;
        if(self.loadCallback) {
            self.loadCallback(self);
        }
    }
}

@end
