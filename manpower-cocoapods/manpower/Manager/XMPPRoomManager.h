//
//  XMPPRoomManager.h
//  manpower
//
//  Created by Brian on 14-6-26.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRoom.h"
#import "DDTTYLogger.h"
#import "DDLog.h"

@interface XMPPRoomManager : NSObject<XMPPRoomStorage>

@property (strong,nonatomic) XMPPStream *xmppStream;
@property (strong,nonatomic) XMPPRoom *xmppRoom;
@property (assign,nonatomic) int isOwner;

-(void)joinRoomWithJid:(XMPPJID *)xmppJID andType:(int)type;
-(void)changeNickname:(NSString *)name withOldNickname:(NSString*)oldName withXMPPJID:(XMPPJID*)xmppJID;
@end
