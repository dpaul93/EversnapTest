//
//  PhotoDetailsHeaderReusableView.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 25.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsHeaderReusableView : UICollectionReusableView

@property (weak, nonatomic, readonly) UILabel *titleLabel;

@property (copy, nonatomic) void (^didTapBackButtonCallback)(PhotoDetailsHeaderReusableView *cell, UIButton *button);

-(void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
