//
//  RLMeInfoCell.m
//  manpower
//
//  Created by Brian on 14-6-30.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLMeInfoCell.h"

@implementation RLMeInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"bg-arrow"];
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self.backImageView setImage:image];
        [self addSubview:self.backImageView];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 7, 72, 72)];
        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
        self.headImageView.layer.masksToBounds = YES;
        [self addSubview:self.headImageView];
        
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 7, 180, 40)];
        self.topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        self.topLabel.textAlignment = NSTextAlignmentLeft;
        self.topLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topLabel];
        
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 48, 115, 40)];
        self.downLabel.font = [UIFont systemFontOfSize:14.0f];
        self.downLabel.textColor = [UIColor grayColor];
        self.downLabel.backgroundColor = [UIColor clearColor];
        self.downLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.downLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
