//
//  NotificationDataHelp.h
//  manpower
//
//  Created by hanjin on 14-6-18.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPManager.h"
#import "ACUtilities.h"
#define MESSAGE_NOTIFICATION @"MESSAGE_NOTIFICATION"
#define MESSAGE_NOTIFICATION_NUM_BADGE @"MESSAGE_NOTIFICATION_NUM_BADGE"

@interface NotificationRequest : NSObject<NSCoding>
@property (strong,nonatomic) XMPPJID * jid;
@property (strong,nonatomic) XMPPJID * myJid;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) UIImage * picImage;
@property (strong,nonatomic) NSString * imageURLString;
@property (strong,nonatomic) NSString * dateStr;
@property (assign,nonatomic) int acceptedState;// 0.未回复  1 .同意  2.拒绝
@property (assign,nonatomic) int requestType;//1.好友 ,2.群组
@property (strong,nonatomic) NSString *reasonStr;
-(id)initWithJid:(XMPPJID *)aJid name:(NSString *)aName requestType:(int)aType acceptedState:(int)aState;
-(BOOL)isEqualToNotificationRequest:(NotificationRequest *)aRequest;

@end
@interface NotificationDataHelp : NSObject
DEFINE_SINGLETON_FOR_HEADER(NotificationDataHelp)
-(NSMutableArray *)currentNotificationList;
-(void)saveNotificationList:(NSMutableArray *)ary;
-(void)saveNotificationRequest:(NotificationRequest *)aRequest;

//通知badge
-(int)currentNotificationBadgeNum;
-(void)saveNotificationBadgeNum:(int)aNum;
@end
