//
//  FriendInfoView.m
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "FriendInfoView.h"
#import "NSData+XMPP.h"

@implementation FriendInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor lightGrayColor];
        self.picImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 60)];
        self.picImgView.backgroundColor=[UIColor redColor];
        [self addSubview:self.picImgView];
                
        self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.picImgView.frame)+20, 10, 100, 30)];
        self.nameLab.backgroundColor=[UIColor clearColor];
        self.nameLab.textColor=[UIColor blackColor];
        self.nameLab.font=[UIFont systemFontOfSize:17.0];
        [self  addSubview:self.nameLab];
        
        
        UITapGestureRecognizer * tuch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchInView)];
        [self addGestureRecognizer:tuch];
    }
    return self;
}
-(void)updateView:(NSDictionary *)dic{

    self.nameLab.text=[dic objectForKey:@"userName"];
    NSString * imgStr=[dic objectForKey:@"photo"];
                       
    if (imgStr.length>0) {
        NSData *base64Data = [imgStr dataUsingEncoding:NSASCIIStringEncoding];
        NSData *decodedData = [base64Data xmpp_base64Decoded];
        UIImage *img = [UIImage imageWithData:decodedData];
        [self.picImgView setImage:img];
    } else {
        
    }
    

}
-(void)tuchInView{
    if ([self.delegate respondsToSelector:@selector(tuchFriendInfoView)]) {
        [self.delegate tuchFriendInfoView];
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
