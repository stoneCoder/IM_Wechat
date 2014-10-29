//
//  SWImageView.m
//  manpower
//
//  Created by WangShunzhou on 14-7-1.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "SWImageView.h"

@interface SWImageView ()
{
    UITapGestureRecognizer *smallIVTap;
    UITapGestureRecognizer *fullScreenIVTap;
    UITapGestureRecognizer *fullScreenIVDoubleTap;
    UIScrollView *scrollView;
    UIImageView *fullScreenIV;
    CGFloat maxScale;
    BOOL fullScreen;
}
@end

@implementation SWImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        maxScale = 2.0;
        self.userInteractionEnabled = YES;
        smallIVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallImageViewTapped:)];
        smallIVTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:smallIVTap];
        
        fullScreenIVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenImageViewTapped:)];
        fullScreenIVTap.numberOfTapsRequired = 1;
        
        fullScreenIVDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenImageViewDoubleTapped:)];
        fullScreenIVDoubleTap.numberOfTapsRequired = 2;
        
        [fullScreenIVTap requireGestureRecognizerToFail:fullScreenIVDoubleTap]; // 双击时禁用单击事件。
        
        fullScreenIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        fullScreenIV.userInteractionEnabled = YES;
        fullScreenIV.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
//        fullScreenIV.contentMode = UIViewContentModeTopLeft;
        
        fullScreen = NO;
        
        scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.minimumZoomScale = 1.0f;
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
        [scrollView addSubview:fullScreenIV];
        [scrollView addGestureRecognizer:fullScreenIVTap];
        [scrollView addGestureRecognizer:fullScreenIVDoubleTap];

    }
    return self;
}

//-(void)setImage:(UIImage *)image{
//    [super setImage:image];
//}

-(void)setMaxScale{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale1 = screenSize.width / fullScreenIV.frame.size.width;      // 图片/屏幕宽度比
    CGFloat scale2 = screenSize.height / fullScreenIV.frame.size.height;      // 图片/屏幕宽度比
    maxScale = MAX(MAX(scale1, scale2),2);
    
    scrollView.maximumZoomScale = maxScale;
}

-(void)smallImageViewTapped:(id)sender{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self convertRect:self.bounds toView:window];

    fullScreenIV.image = self.image;
    [window addSubview:scrollView];
    fullScreen = YES;
//        DDLogVerbose(@"x = %f, y = %f, w = %f, h = %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);

    CGSize imageSize = fullScreenIV.image.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGPoint screenCenter = ccp(screenSize.width * 0.5,screenSize.height*0.5);
    CGRect imageViewFrame = CGRectZero;
    
    CGFloat imageScaleFactor = imageSize.width / imageSize.height;
    CGFloat screenScaleFactor = screenSize.width / screenSize.height;
    
    // 图片宽高比大于屏幕宽高比，缩放宽。
    if (imageScaleFactor > screenScaleFactor) {
        if (imageSize.width > screenSize.width) {
            imageViewFrame.size.width = screenSize.width;
            imageViewFrame.size.height = imageSize.height * screenSize.width / imageSize.width;
        }else{
            imageViewFrame.size = imageSize;
        }
    }else{
        // 图片宽高比小于屏幕宽高比，缩放高。
        if (imageSize.height > screenSize.height) {
            imageViewFrame.size.height = screenSize.height;
            imageViewFrame.size.width = imageSize.width * screenSize.height / imageSize.height;
        }else{
            imageViewFrame.size = imageSize;
        }
    }
    imageViewFrame.origin.x = screenCenter.x - (imageViewFrame.size.width * 0.5);
    imageViewFrame.origin.y = screenCenter.y - (imageViewFrame.size.height * 0.5);
    
    [fullScreenIV setFrame:rect];
    [scrollView setFrame:[UIScreen mainScreen].bounds];
    [scrollView setBackgroundColor:[UIColor colorWithWhite:0. alpha:0]];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
        [UIApplication sharedApplication].statusBarHidden = YES;
        [fullScreenIV setFrame: imageViewFrame];
        [scrollView setBackgroundColor:[UIColor colorWithWhite:0. alpha:1]];
    } completion:^(BOOL flag){
        scrollView.contentSize = fullScreenIV.frame.size;
        [self setMaxScale];
    }];
}

-(void)fullScreenImageViewTapped:(UITapGestureRecognizer*)tap{
//    if (scrollView.zoomScale == 1) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [self convertRect:self.bounds toView:window];
        [scrollView setZoomScale:1];
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
            [fullScreenIV setFrame:rect];
            [scrollView setBackgroundColor:[UIColor colorWithWhite:0. alpha:0]];
        } completion:^(BOOL flag){
            [scrollView removeFromSuperview];
        }];
        fullScreen = NO;

//    }else{
//        [scrollView setZoomScale:1 animated:YES];
//    }
}

-(void)fullScreenImageViewDoubleTapped:(UITapGestureRecognizer*)tap{
    CGFloat zoomScale;

    if (scrollView.zoomScale == 1) {
        CGPoint location = [tap locationInView:scrollView];
        CGPoint offset = CGPointZero;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [scrollView setZoomScale:maxScale animated:YES];

        // 放大后高、宽都大于屏幕尺寸，按点击坐标偏移。
        // 聪明一点，当点击处于屏幕边缘20%（这个值可以探讨）的区域时，可以认为用户是想看最旁边的内容，直接偏移到屏幕边缘。
        CGFloat smartEdge = 0.20;
        CGFloat maxY = 0;
        
        if (fullScreenIV.frame.size.height / maxScale >= screenSize.height ) {
            // 点其他区域 原图高大于等于屏幕高
            maxY = (maxScale - 1) * screenSize.height;
            offset.y = location.y * ( maxScale - 1 );
        }else{
            // 点其他区域 原图高小于屏幕高
            CGFloat originalImageHeight = fullScreenIV.frame.size.height / maxScale;
            maxY = fullScreenIV.frame.size.height - screenSize.height;
            offset.y = location.y - (screenSize.height - originalImageHeight);
            if (location.y < 0 ) {
                offset.y = 0;
            }else if(location.y > originalImageHeight){
                offset.y = maxY;
            }
        }
        
        if (location.y > (screenSize.height * (1 - smartEdge)) || offset.y > maxY) {
            // 点下方
            offset.y = maxY;
        }else if (location.y < screenSize.height * smartEdge){
            // 点上方
            offset.y = 0;
        }
        offset.y = offset.y < 0 ? 0 :offset.y;
        offset.y = offset.y > maxY ? maxY :offset.y;
        
        
        CGFloat maxX = 0;
        if (fullScreenIV.frame.size.width / maxScale >= screenSize.width ) {
            // 点其他区域 原图宽大于等于屏幕宽
            maxX = (maxScale - 1) * screenSize.width;
            offset.x = location.x * ( maxScale - 1 );
        }else{
            // 点其他区域 原图宽小于屏幕宽
            CGFloat originalImageWidth = fullScreenIV.frame.size.width / maxScale;
            maxX = fullScreenIV.frame.size.width - screenSize.width;
            offset.x = location.x - (screenSize.width - originalImageWidth);
            if (location.x < 0 ) {
                offset.x = 0;
            }else if(location.x > originalImageWidth){
                offset.x = maxX;
            }
        }
        
        if (location.x > (screenSize.width * (1 - smartEdge)) || offset.x > maxX) {
            // 点右方
            offset.x = maxX;
        }else if (location.x < screenSize.width * smartEdge){
            // 点左方
            offset.x = 0;
        }
        
        offset.x = offset.x < 0 ? 0 :offset.x;
        offset.x = offset.x > maxX ? maxX :offset.x;
        
        // 放大后的宽小于屏幕宽度，只偏移Y轴。
        if (fullScreenIV.frame.size.width < screenSize.width) {
            location.x = 0;
        } else if (fullScreenIV.frame.size.height < screenSize.height){
            // 放大后的高小于屏幕高度，只偏移X轴。
            location.y = 0;
        }

        scrollView.contentOffset = offset;

    }else{
        zoomScale = 1;
        [scrollView setZoomScale:zoomScale animated:YES];

        scrollView.contentOffset = ccp(0,0);
    }
}



#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return fullScreenIV;
}

-(void)scrollViewDidZoom:(UIScrollView *)aScrollView{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? \
    
    scrollView.contentSize.width/2 : xcenter;
    
    //同上，此处修改y值
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? \
    
    scrollView.contentSize.height/2 : ycenter;
    
    [fullScreenIV setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
//    NSLog(@"%@",NSStringFromCGPoint(aScrollView.contentOffset));
//    NSLog(@"%f",aScrollView.zoomScale);
}

@end
