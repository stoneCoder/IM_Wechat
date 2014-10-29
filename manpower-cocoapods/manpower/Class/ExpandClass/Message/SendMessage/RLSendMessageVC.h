//
//  RLSendMessage.h
//  manpower
//
//  Created by WangShunzhou on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseTableVC.h"
#import "XMPPRoom.h"
#import "RLGroupVO.h"
#import "XMPPRoomManager.h"
@class XMPPJID;
@class XMPPManager;
@class SendBox;
@class RLGroupVO;
@class FaceBoard;

@interface RLSendMessageVC : RLBaseTableVC{
    XMPPManager *xmpp;
    NSMutableArray *dataArr;
    SendBox *sendBox;
    XMPPRoom *xmppRoom;
}

@property(strong, nonatomic) XMPPJID* friendJID;        // 聊天对象的JID
@property(strong, nonatomic) XMPPJID* MyJID;            // 自己的JID
@property(strong, nonatomic) NSString* type;    //chat, groupchat
@property(strong, nonatomic) UIButton *rightBtn;
@property (strong,nonatomic) RLGroupVO * groupVO;
@property (strong,nonatomic) XMPPRoomManager  *xmppRoomManager;
@property (strong,nonatomic) NSMutableDictionary  *cachedImageDic;
@property (assign,nonatomic) int isInfo;//判断是否是从资料进入的
@property(strong, nonatomic) FaceBoard *faceBoard;
@property(strong, nonatomic) NSDate *lastMessageTime;
@property(nonatomic, assign) NSInteger badgeNum; // badgeNum值为-1时，左上角显示“返回”；否则，显示“消息”


-(void)infoBtnClick:(UIButton *)sender;
-(void)moveSendBoxToBottom:(BOOL)animated;
@end
