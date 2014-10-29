//
//  GroupInfoHeadView.m
//  manpower
//
//  Created by hanjin on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "GroupInfoHeadView.h"

@implementation GroupInfoHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 124)];
        [self.backImgView setImage:[UIImage imageNamed:@"contact_bg"]];
        [self addSubview:self.backImgView];
        
        self.picImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 84, 80, 80)];
        self.picImgView.backgroundColor=[UIColor clearColor];
        self.picImgView.layer.cornerRadius=self.picImgView.frame.size.width/2;
        self.picImgView.layer.masksToBounds=YES;
        [self addSubview:self.picImgView];
        
        
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.picImgView.frame)+10, 84, 200, 30)];
        self.nameLab.font=[UIFont systemFontOfSize:20];
        self.nameLab.backgroundColor=[UIColor clearColor];
        [self addSubview:self.nameLab];
        
        self.subjectLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.picImgView.frame)+10, 124, 200, 30)];
        self.subjectLab.font=[UIFont systemFontOfSize:14];
        self.subjectLab.textColor = [UIColor lightGrayColor];
        self.subjectLab.backgroundColor=[UIColor clearColor];
        [self addSubview:self.subjectLab];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, self.frame.size.width, 1)];
        UIColor *color = [UIColor lightGrayColor];
        [color colorWithAlphaComponent:0.5f];
        [lineView setBackgroundColor:color];
        [self addSubview:lineView];
        
    }
    return self;
}
-(void)loadViewWithName:(NSString *)aName Subject:(NSString *)aSubject{
    self.nameLab.text=aName;
    self.subjectLab.text=aSubject;
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
