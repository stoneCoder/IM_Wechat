//
//  RLInfoCell.m
//  manpower
//
//  Created by Brian on 14-6-30.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLInfoCell.h"

@implementation RLInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, self.frame.size.height)];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.backImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.backImageView];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 190, self.frame.size.height)];
        self.infoLabel.font = [UIFont systemFontOfSize:15.0f];
        self.infoLabel.textAlignment = NSTextAlignmentRight;
        self.infoLabel.textColor = [UIColor grayColor];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.infoLabel];
        
    }
    return self;
}

-(void)updateBackImge:(int)type
{
    if (type == 0) {
        [self.backImageView setImage:[UIImage imageNamed:@"bg"]];
        self.infoLabel.frame = CGRectMake(100, 0, 200, self.frame.size.height);
    }
    else if (type == 1)
    {
        [self.backImageView setImage:[UIImage imageNamed:@"bg-arrow"]];
    }
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
