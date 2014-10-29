//
//  GrayPageControl.m
//  manpower
//
//  Created by WangShunzhou on 14-7-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//


#import "GrayPageControl.h"
@interface GrayPageControl(){
    CGFloat startX;
    CGFloat margin;
    CGFloat dotEdge;
}
@end


@implementation GrayPageControl

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {

        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];
        
        margin = 18;
        dotEdge = 6;
        [self setCurrentPage:1];
	}
	return self;
}

-(void)layoutSubviews{
    startX = (self.frame.size.width - self.numberOfPages * (margin + dotEdge) + dotEdge) * 0.5;

    CGFloat lastDotX = startX;
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        //设置dot位置
        if ( [dot isKindOfClass:UIView.class] ) {
            CGRect frame = dot.frame;
            frame.origin.y = -35;
            lastDotX = frame.origin.x = lastDotX + margin;
            dot.frame = frame;
        }
    }
}

- (void)updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        CGRect frame = dot.frame;
        frame.size = CGSizeMake(6, 6);
        dot.frame = frame;
        if (i == self.currentPage) {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = activeImage;
            }
            else {
                dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
            }
        }
        else {
            if ( [dot isKindOfClass:UIImageView.class] ) {
                ((UIImageView *) dot).image = inactiveImage;
            }
            else {
                dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
            }
        }
    }
}

-(void) setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    [self updateDots];
}

@end
