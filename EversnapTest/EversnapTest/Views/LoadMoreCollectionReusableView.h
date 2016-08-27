//
//  LoadMoreCollectionReusableView.h
//  EversnapTest
//
//  Created by Pavlo Deynega on 24.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreCollectionReusableView : UICollectionReusableView

@property (copy, nonatomic) void (^loadCallback)(LoadMoreCollectionReusableView *reusable);

@property (assign, nonatomic) CGFloat minFrameHeight;

@end
