//
//  IMMessageRecent.h
//  manpower
//
//  Created by WangShunzhou on 14-6-24.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IMMessageRecent : NSManagedObject

@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * bareJID;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * type;  // groupchat, chat
@property (nonatomic) NSInteger msgType;  //audio, text, image
@property (nonatomic) NSInteger unreadMsgNum;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString * myBareJID;
@property (nonatomic) NSInteger order;    // order大于0的消息为置顶消息，逆序排列
@property (nonatomic, retain) NSString * avatar;


-(BOOL)save;
@end
