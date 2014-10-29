//
//  SWImageView.h
//  manpower
//
//  Created by WangShunzhou on 14-7-1.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoProtocol.h"

@interface SWZoomingScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic) NSUInteger index;
@property (nonatomic) id <MWPhoto> photo;

+(SWZoomingScrollView*)zoomingScrollViewWithImage:(UIImage*)image;
- (void)prepareForReuse;
- (void)setMaxMinZoomScalesForCurrentBounds;
@end
