//
//  RLGroupChatVC.m
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupChatVC.h"
#import "XMPPRoom.h"
#import "XMPPManager.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "RLGroupSetInfoVC.h"
// Log levels: off, error, warn, info, verbose
@interface RLGroupChatVC ()<XMPPRoomStorage>
{
    XMPPStream *xmppStream;
    XMPPRoom *xmppRoom;
    int isOwner; //0 群主  1 管理员 2 成员 3 不是成员
}
@end

@implementation RLGroupChatVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeNaviLeftButtonVisible:YES];

    [self setTitleText:self.groupVO.roomName];
    
    
    xmppStream = [XMPPManager sharedInstance].xmppStream;
	
    // Configure xmppRoom
    XMPPJID *roomJID=[XMPPJID jidWithString:self.groupVO.roomJid];
	xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
	
	[xmppRoom activate:xmppStream];
	[xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSString *nickName = [NSString stringWithFormat:@"%@/%@",xmppStream.myJID.user,[xmppStream.myJID bare]];
    [xmppRoom joinRoomUsingNickname:nickName history:nil];
    
    self.sendBox = [SendBox sendBox];
    self.sendBox.delegate = self;
    [self.view addSubview:self.sendBox];
    
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeInfoDark];
    [rightBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLICK
/**
 *  功能:群信息
 */

-(void)infoBtnClick{
    RLGroupSetInfoVC * infoVC=[[RLGroupSetInfoVC alloc]initWithNibName:nil bundle:nil];
    infoVC.xmppRoom = xmppRoom;
    infoVC.isOwner= isOwner;
    infoVC.roomJID=xmppRoom.roomJID;
    infoVC.roomSubject=xmppRoom.roomSubject;
    [self.navigationController pushViewController:infoVC animated:YES];
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
	[xmppRoom fetchConfigurationForm];
	[xmppRoom fetchBanList];
	[xmppRoom fetchMembersList];
	[xmppRoom fetchModeratorsList];
    
    
    //用户进入的当前房间(群组)
    [XMPPManager sharedInstance].currentJoinedRoom=xmppRoom;
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{

    DDLogInfo(@"occupantJID is --------------->%@",occupantJID);

}

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
    if ([groupRole isEqualToString:@"participant"]) {
        if ([affiliationRole isEqualToString:@"owner"]) {
            isOwner = 0;
        }else if ([affiliationRole isEqualToString:@"member"])
        {
            isOwner = 2;
        }
    }else if ([groupRole isEqualToString:@"nono"])
    {
        isOwner = 3;
    }
    
}

- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
     DDLogInfo(@"%@------------------>2",message);
}

- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}

- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
	return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark sendbox delegate
-(void)keyboardWillShow:(SendBox*)sendBox
{
    
}

-(void)keyboardWillBeHidden:(SendBox*)sendBox
{
    
}
@end
