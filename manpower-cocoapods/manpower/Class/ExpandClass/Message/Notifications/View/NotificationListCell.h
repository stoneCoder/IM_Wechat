//
//  NotificationListCell.h
//  manpower
//
//  Created by hanjin on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationDataHelp.h"
@protocol NotificationListCellDelegate <NSObject>
@required
-(void)refuseWithRequest:(NotificationRequest *)aRequest index:(int)aIndex;
-(void)agreeWithRequest:(NotificationRequest *)aRequest index:(int)aIndex;
@end
@interface NotificationListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;             //通知类型标题
@property (weak, nonatomic) IBOutlet UILabel *dateLab;              //日期
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;     //通知用户图片
@property (weak, nonatomic) IBOutlet UILabel *nameLab;              //通知用户名称
@property (weak, nonatomic) IBOutlet UIView *acceptView;            //回复view
@property (weak, nonatomic) IBOutlet UILabel *replyInfoLab;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;


@property (strong,nonatomic) NotificationRequest * reauest;
@property (assign,nonatomic) id<NotificationListCellDelegate> delegate;
@property (assign,nonatomic) int index;

-(void)loadCellWithRequest:(NotificationRequest *)aRequest;
@end
