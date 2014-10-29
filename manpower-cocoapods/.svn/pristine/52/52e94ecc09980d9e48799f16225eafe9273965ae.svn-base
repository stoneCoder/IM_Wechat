//
//  FriendSectionView.m
//  manpower
//
//  Created by hanjin on 14-6-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "FriendSectionView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@implementation FriendSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        if (iOS7) {
            UIImageView * bgImgView=[[UIImageView alloc]initWithFrame:self.bounds];
            bgImgView.image=[UIImage imageNamed:@"friendlist_cell_bg"];
            self.backgroundView=bgImgView;
        } else {
            UIView * bgView=[[UIView alloc]initWithFrame:self.bounds];
            bgView.backgroundColor=[UIColor whiteColor];
            UIImageView * bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
            [bgImageView setImage:[UIImage imageNamed:@"friendlist_cell_bg"]];
            [bgView addSubview:bgImageView];
            self.backgroundView=bgView;
        }
        self.sectionImageView=[[UIImageView alloc]initWithFrame:CGRectMake(32,15,18,18)];
        [self.sectionImageView setImage:[UIImage imageNamed:@"friend_arrow_right-1"]];
        [self.contentView addSubview:self.sectionImageView];
        
        self.groupLab=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 100, 20)];
        self.groupLab.font=[UIFont systemFontOfSize:14.0];
        self.groupLab.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.groupLab];
        
        self.numInfoLab=[[UILabel alloc]initWithFrame:CGRectMake(320-60, 15, 50, 20)];
        self.numInfoLab.textAlignment=NSTextAlignmentRight;
        self.numInfoLab.backgroundColor=[UIColor clearColor];
        self.numInfoLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.numInfoLab];
        
        
        [self.sectionImageView setImage:[UIImage imageNamed:@"friend_arrow_right-1"]];
        
        //长按
        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
        longPress.delegate=self;
        longPress.minimumPressDuration=0.2;
        [self.contentView addGestureRecognizer:longPress];
        
        //点击
        UITapGestureRecognizer * click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchInView:)];
        [self.contentView addGestureRecognizer:click];
    }
    return self;
}
//长按事件的实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //UIGestureRecognizerStateEnded
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longTuchInSecionView:)]) {
            [self.delegate longTuchInSecionView:self];
        }
    }
    
    
}
//点击
-(void)tuchInView:(UITapGestureRecognizer *)gestureRecognizer{
    if ([self.delegate respondsToSelector:@selector(clickSectionView:)]) {
        [self.delegate clickSectionView:self.index];
    }
    
}
/**
 *  功能:刷新 view
 */

-(void)loadViewWithName:(NSString *)aName numInfo:(NSString *)info{
    self.groupLab.text=aName;
    self.numInfoLab.text=info;
}
-(void)loadViewWithSectionModel:(SectionInfoModel *)aModel numInfo:(NSString *)info{
    self.model=aModel;
    self.groupLab.text=aModel.name;
    if ([info isEqualToString:@"0/0"]) {
        self.numInfoLab.hidden=YES;
    } else {
        self.numInfoLab.hidden=NO;
        self.numInfoLab.text=info;
    }
    
    
    if (aModel.isSelected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.sectionImageView.transform = CGAffineTransformRotate(self.sectionImageView.transform, DEGREES_TO_RADIANS(90));
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.sectionImageView.transform = CGAffineTransformRotate(self.sectionImageView.transform, DEGREES_TO_RADIANS(0));
        }];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}


@end
