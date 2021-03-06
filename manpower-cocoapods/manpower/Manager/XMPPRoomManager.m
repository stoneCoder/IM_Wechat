//
//  XMPPRoomManager.m
//  manpower
//
//  Created by Brian on 14-6-26.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "XMPPRoomManager.h"
#import "XMPPManager.h"
#import "RLMyInfo.h"

@implementation XMPPRoomManager

-(void)joinRoomWithJid:(XMPPJID *)xmppJID andType:(int)type
{
    RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
    
    self.xmppStream = [XMPPManager sharedInstance].xmppStream;
	self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:xmppJID];
	[self.xmppRoom activate:self.xmppStream];
	[self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSString *nickName = [NSString stringWithFormat:@"%@/%@",[RLMyInfo sharedRLMyInfo].name,[self.xmppStream.myJID bare]];

    NSXMLElement *history = nil;
    history = [NSXMLElement elementWithName:@"history"];
//    [history addAttributeWithName:@"maxstanzas" stringValue:@"20"];
    [history addAttributeWithName:@"since" stringValue:myInfo.registrationDate];
    if (type != 3) {
        [self.xmppRoom joinRoomUsingNickname:nickName history:history];
    }
}

-(void)changeNickname:(NSString *)name withOldNickname:(NSString*)oldName withXMPPJID:(XMPPJID*)xmppJID{
    self.xmppStream = [XMPPManager sharedInstance].xmppStream;
//    XMPPJID *myJID = self.xmppStream.myJID;
    
    self.xmppStream = [XMPPManager sharedInstance].xmppStream;
	self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:xmppJID];
    
    NSString *nickname = [NSString stringWithFormat:@"%@/%@",name,[self.xmppStream.myJID bare]];
//    NSString *oldNickname = [NSString stringWithFormat:@"%@/%@",oldName,[self.xmppStream.myJID bare]];
    [self.xmppRoom changeNickname:nickname];
//    XMPPPresence *presence = [XMPPPresence presence];
//    [presence addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@/%@",myJID.bare,nickname]];
//    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@",xmppJID.bare,oldNickname]];
//    [presence addAttributeWithName:@"id" stringValue:@"idididididi"];
//    [self.xmppStream sendElement:presence];
}

#pragma mark XMPPRoom Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
	[self.xmppRoom fetchConfigurationForm];
	[self.xmppRoom fetchBanList];
	[self.xmppRoom fetchMembersList];
	[self.xmppRoom fetchModeratorsList];
    //用户进入的当前房间(群组)
    [XMPPManager sharedInstance].currentJoinedRoom = self.xmppRoom;
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
//	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}
//- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
//    
//    DDLogInfo(@"occupantJID is --------------->%@",occupantJID);
//    
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRoomStorage Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    NSXMLElement *xmlGroupRole = [presence elementForName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    DDXMLNode *roleItem = [[xmlGroupRole elementForName:@"item"] attributeForName:@"role"];
    DDXMLNode *affiliationItem = [[xmlGroupRole elementForName:@"item"] attributeForName:@"affiliation"];
    NSString *groupRole = [roleItem stringValue];
    NSString *affiliationRole = [affiliationItem stringValue];
    if ([groupRole isEqualToString:@"participant"] || [groupRole isEqualToString:@"moderator"]) {
        if ([affiliationRole isEqualToString:@"owner"]) {
            self.isOwner = 0;
        }else if ([affiliationRole isEqualToString:@"member"])
        {
            self.isOwner = 2;
        }
        else if ([affiliationRole isEqualToString:@"none"])
        {
            self.isOwner = 2;
        }
    }else if ([groupRole isEqualToString:@"none"])
    {
        self.isOwner = 3;
    }
}

- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
//    DDLogVerbose(@"%@------------------>2",message);
}

- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}

- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
	return YES;
}
@end
