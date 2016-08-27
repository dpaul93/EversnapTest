//
//  PhotoDetailsHeaderReusableView.m
//  EversnapTest
//
//  Created by Pavlo Deynega on 25.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "PhotoDetailsHeaderReusableView.h"

@interface PhotoDetailsHeaderReusableView()

@property (weak, nonatomic, readwrite) UILabel *titleLabel;
//@property (weak, nonatomic) UIView *titleView;
@property (weak, nonatomic) UIButton *backButton;

@end

@implementation PhotoDetailsHeaderReusableView

#pragma mark - Initialization

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        UILabel *titleLabel = [UILabel new];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:20.0f].active = YES;
        [titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        self.titleLabel = titleLabel;
        
        UIButton *backButton = [UIButton new];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backButton setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backButton addTarget:self action:@selector(didPressBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        CGFloat verticalInsets = CGRectGetHeight(frame) < 64.0f ? 0.0f : 10.0f;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(verticalInsets, 0.0f, verticalInsets, 25.0f);
        [backButton.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [backButton.centerYAnchor constraintEqualToAnchor:titleLabel.centerYAnchor].active = YES;
        [backButton.heightAnchor constraintEqualToAnchor:titleLabel.heightAnchor].active = YES;;
        [backButton.widthAnchor constraintEqualToAnchor:backButton.heightAnchor multiplier:2.0 constant:0.0f].active = YES;
        self.backButton = backButton;
    }
    
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.alpha = 0.0f;
}

#pragma mark - Actions

-(void)didPressBackButton:(UIButton*)sender {
    if(self.didTapBackButtonCallback) {
        self.didTapBackButtonCallback(self, sender);
    }
}

-(void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat duration = animated ? 0.25f : 0.0f;
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;
    }];
}

@end
