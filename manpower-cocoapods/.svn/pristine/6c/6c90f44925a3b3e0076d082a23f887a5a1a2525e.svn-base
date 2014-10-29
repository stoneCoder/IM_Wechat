//
//  SWImageView.m
//  manpower
//
//  Created by WangShunzhou on 14-7-1.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "SWZoomingScrollView.h"

@interface SWZoomingScrollView ()
{
//    UITapGestureRecognizer *smallIVTap;
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UIImageView *imageView;
    CGFloat maxScale;
//    BOOL fullScreen;
}
@end

@implementation SWZoomingScrollView

+(SWZoomingScrollView*)zoomingScrollViewWithImage:(UIImage*)image{
    return [[SWZoomingScrollView alloc] initWithImage:image];
}

- (id)initWithImage:(UIImage*)image{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        maxScale = 2.0;
        self.userInteractionEnabled = YES;
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTapped:)];
        singleTap.numberOfTapsRequired = 1;
        
        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap]; // 双击时禁用单击事件。
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        imageView.image = image;

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = maxScale;
        self.delegate = self;
        [self addSubview:imageView];
        [self addGestureRecognizer:singleTap];
        [self addGestureRecognizer:doubleTap];
        
        [self setupViews];
    }
    return self;

}


- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
    return nil;
}


-(void)setMaxScale{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale1 = screenSize.width / imageView.frame.size.width;      // 图片/屏幕宽度比
    CGFloat scale2 = screenSize.height / imageView.frame.size.height;      // 图片/屏幕宽度比
    maxScale = MAX(MAX(scale1, scale2),2);
    
    self.maximumZoomScale = maxScale;
}

-(void)setupViews{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    CGRect rect = [self convertRect:self.bounds toView:window];
//
//    [window addSubview:self];
//    fullScreen = YES;
//        DDLogVerbose(@"x = %f, y = %f, w = %f, h = %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);

    CGSize imageSize = imageView.image.size;
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
    
//    [imageView setFrame:rect];
    [self setFrame:[UIScreen mainScreen].bounds];
    [self setBackgroundColor:[UIColor colorWithWhite:0. alpha:0]];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(){
//        [UIApplication sharedApplication].statusBarHidden = YES;
        [imageView setFrame: imageViewFrame];
        [self setBackgroundColor:[UIColor colorWithWhite:0. alpha:1]];
//    } completion:^(BOOL flag){
        self.contentSize = imageView.frame.size;
        [self setMaxScale];
//    }];
}

- (void)prepareForReuse {
    maxScale = 2.0;
    imageView.image = nil;
    _index = NSUIntegerMax;
}


#pragma UIGestures
-(void)imageViewSingleTapped:(UITapGestureRecognizer*)tap{
//    if (self.zoomScale == 1) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        CGRect rect = [self convertRect:self.bounds toView:window];
//        [self setZoomScale:1];
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
//            [imageView setFrame:rect];
//            [self setBackgroundColor:[UIColor colorWithWhite:0. alpha:0]];
//        } completion:^(BOOL flag){
//            [self removeFromSuperview];
//        }];

//    }else{
//        [self setZoomScale:1 animated:YES];
//    }
}

-(void)imageViewDoubleTapped:(UITapGestureRecognizer*)tap{
    CGFloat zoomScale;

    if (self.zoomScale == 1) {
        CGPoint location = [tap locationInView:self];
        CGPoint offset = CGPointZero;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [self setZoomScale:maxScale animated:YES];

        // 放大后高、宽都大于屏幕尺寸，按点击坐标偏移。
        // 聪明一点，当点击处于屏幕边缘20%（这个值可以探讨）的区域时，可以认为用户是想看最旁边的内容，直接偏移到屏幕边缘。
        CGFloat smartEdge = 0.20;
        CGFloat maxY = 0;
        
        if (imageView.frame.size.height / maxScale >= screenSize.height ) {
            // 点其他区域 原图高大于等于屏幕高
            maxY = (maxScale - 1) * screenSize.height;
            offset.y = location.y * ( maxScale - 1 );
        }else{
            // 点其他区域 原图高小于屏幕高
            CGFloat originalImageHeight = imageView.frame.size.height / maxScale;
            maxY = imageView.frame.size.height - screenSize.height;
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
        if (imageView.frame.size.width / maxScale >= screenSize.width ) {
            // 点其他区域 原图宽大于等于屏幕宽
            maxX = (maxScale - 1) * screenSize.width;
            offset.x = location.x * ( maxScale - 1 );
        }else{
            // 点其他区域 原图宽小于屏幕宽
            CGFloat originalImageWidth = imageView.frame.size.width / maxScale;
            maxX = imageView.frame.size.width - screenSize.width;
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
        if (imageView.frame.size.width < screenSize.width) {
            location.x = 0;
        } else if (imageView.frame.size.height < screenSize.height){
            // 放大后的高小于屏幕高度，只偏移X轴。
            location.y = 0;
        }

        self.contentOffset = offset;

    }else{
        zoomScale = 1;
        [self setZoomScale:zoomScale animated:YES];

        self.contentOffset = ccp(0,0);
    }
}


- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail if no image
	if (imageView.image == nil) return;
    
	// Reset position
	imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Image is smaller than screen so no zooming!
	if (xScale >= 1 && yScale >= 1) {
		minScale = 1.0;
	}
	
	// Set min/max zoom
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = 1;
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }
    
    // Layout
	[self setNeedsLayout];
    
}


#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)self
{
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)aScrollView{
    
    CGFloat xcenter = self.center.x , ycenter = self.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = self.contentSize.width > self.frame.size.width ? \
    
    self.contentSize.width/2 : xcenter;
    
    //同上，此处修改y值
    
    ycenter = self.contentSize.height > self.frame.size.height ? \
    
    self.contentSize.height/2 : ycenter;
    
    [imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
//    NSLog(@"%@",NSStringFromCGPoint(aScrollView.contentOffset));
//    NSLog(@"%f",aScrollView.zoomScale);
}

@end
