//
//  NotificationListCell.m
//  manpower
//
//  Created by hanjin on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "NotificationListCell.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation NotificationListCell

- (void)awakeFromNib
{
    // Initialization code
    self.picImageView.layer.cornerRadius=self.picImageView.frame.size.width/2;
    self.picImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)refuseBtnClick:(id)sender {
    self.reauest.acceptedState=2;
    if ([self.delegate respondsToSelector:@selector(refuseWithRequest:index:)]) {
        [self.delegate refuseWithRequest:self.reauest index:self.index];
    }
}
- (IBAction)agreeBtnClick:(id)sender {
    self.reauest.acceptedState=1;
    if ([self.delegate respondsToSelector:@selector(agreeWithRequest:index:)]) {
        [self.delegate agreeWithRequest:self.reauest index:self.index];
    }
}

-(void)loadCellWithRequest:(NotificationRequest *)aRequest
{
    self.reauest=aRequest;
    
    self.dateLab.text=aRequest.dateStr;
    
    if (aRequest.requestType==1) {//好友
      self.titleLab.text=@"好友申请";
    } else if (aRequest.requestType==2){//群组
      self.titleLab.text=@"加群申请";
    }
    
    self.nameLab.text=aRequest.name;
//    if (aRequest.picImage) {
//        self.picImageView.image=aRequest.picImage;
//    } else {
//        self.picImageView.image=[UIImage imageNamed:@"defaultPerson"];
//    }

    if (aRequest.imageURLString) {
        NSURL *url = [NSURL URLWithString:aRequest.imageURLString];
        [self.picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultPerson"] options:SDWebImageRetryFailed];
    } else {
        self.picImageView.image=[UIImage imageNamed:@"defaultPerson"];
    }
    
    
    switch (aRequest.acceptedState) {
        case 0:
             self.replyInfoLab.hidden=YES;
            self.refuseBtn.hidden=NO;
            self.agreeBtn.hidden=NO;
            break;
        case 1:{//同意
            self.replyInfoLab.hidden=NO;
            self.replyInfoLab.text=@"你已经同意了!";
            self.refuseBtn.hidden=YES;
            self.agreeBtn.hidden=YES;
        }
            break;
        case 2:{//拒绝
            self.replyInfoLab.hidden=NO;
            self.replyInfoLab.text=@"你已经拒绝了!";
            self.refuseBtn.hidden=YES;
            self.agreeBtn.hidden=YES;
        }
            break;
            
        default:
            break;
    }
    
}
@end
