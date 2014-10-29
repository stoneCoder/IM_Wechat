//
//  TopTabView.m
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "TopTabView.h"

@implementation TopTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleAry
{
    self = [super initWithFrame:frame];
    if (self) {
        if (titleAry && titleAry.count>0) {
            UIButton * leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame=CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
            leftBtn.adjustsImageWhenHighlighted=NO;
            [leftBtn setImage:[UIImage imageNamed:@"nav_message_sel"] forState:UIControlStateSelected];
             [leftBtn setImage:[UIImage imageNamed:@"nav_message"] forState:UIControlStateNormal];
            leftBtn.selected=YES;
            leftBtn.tag=1;
            self.selectButton=leftBtn;
            [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:leftBtn];
            
            UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame=CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
            rightBtn.tag=2;
            rightBtn.adjustsImageWhenHighlighted=NO;
            [rightBtn setImage:[UIImage imageNamed:@"nav_notifocation_sel"] forState:UIControlStateSelected];
            [rightBtn setImage:[UIImage imageNamed:@"nav_notifocation"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightBtn];
        }
    }
    return self;
}

-(void)btnClick:(UIButton *)sender
{
    UIButton* btn = sender;
    if (self.selectButton.tag != btn.tag)
    {
        self.selectButton.selected = NO;
        self.selectButton = btn;
        self.selectButton.selected = YES;
    }
    [self.delegate tabBarSelected:btn.tag];
    
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
