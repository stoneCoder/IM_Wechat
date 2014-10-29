
//
//  RLGroupSearchResultVC.m
//  manpower
//
//  Created by hanjin on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupSearchResultVC.h"
#import "RLGroupLogic.h"
#import "IMAlert.h"
#import "XMPPRoom.h"
#import "XMPPManager.h"
#import "RLGroupMemberJoinVC.h"
#import "RLGroupSetInfoVC.h"

@interface RLGroupSearchResultVC()<XMPPRoomStorage>
{
    NSString * showMsg;
    XMPPStream *xmppStream;
    XMPPRoom *xmppRoom;
}
@property (weak, nonatomic) IBOutlet UILabel *roomJidStrLab;
@property (weak, nonatomic) IBOutlet UILabel *roomDescriptionLab;
@property (strong,nonatomic) RLGroupLogic * logic;
@property (strong,nonatomic) NSDictionary * infoDic;
@property (strong, nonatomic) IBOutlet UILabel *roomJidLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomDesLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@property (assign,nonatomic) int isOwner;
@property (strong, nonatomic) UIButton *rightBtn;
@end

@implementation RLGroupSearchResultVC

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
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"查找结果"];
    [self makeNaviLeftButtonVisible:YES];

    self.rightBtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;
    self.logic=[RLGroupLogic sharedRLGroupLogic];
    
    [self getListDataWithPage];
    
    
}

-(void)getListDataWithPage{
    [self showHUD];
    XMPPJID * jid= [XMPPManager sharedInstance].xmppStream.myJID;
    [self.logic searchGroupInfoByName:self.jidStr andUserJID:[jid bare] success:^(id json) {
        [self hideHUD];
        NSDictionary * dic=(NSDictionary *)json;
        if ([[dic objectForKey:@"mucroomVo"] count] == 0) {
            self.rightBtn.hidden = YES;
            self.roomJidStrLab.hidden = YES;
            self.roomDescriptionLab.hidden = YES;
            self.roomJidLabel.hidden = YES;
            self.roomDesLabel.hidden = YES;
            self.emptyLabel.hidden = NO;
            self.emptyLabel.text = @"当前无数据记录！";
            self.emptyLabel.textColor = [UIColor grayColor];
            self.emptyLabel.textAlignment = NSTextAlignmentCenter;
            self.emptyLabel.font = [UIFont systemFontOfSize:12.0f];
        }else
        {
            self.infoDic=[dic objectForKey:@"mucroomVo"];
            showMsg=[dic objectForKey:@"showMsg"];
            self.roomJidStrLab.text=[self.infoDic objectForKey:@"roomName"];
            self.roomDescriptionLab.text=[self.infoDic objectForKey:@"roomDescription"];
            if ([[dic objectForKey:@"isExist"] intValue] == 1) {
                self.isOwner = 2;
            }else
            {
                self.isOwner = 3;
            }
            //查询用户在群中的角色
            [self getRoleFromRoomWithRoomJID:[self.infoDic objectForKey:@"roomJid"]];
        }
    } failure:^(NSError *err) {
         [self failureHideHUD];
    }];
}

-(void)getRoleFromRoomWithRoomJID:(NSString *)jidStr
{
    xmppStream = [XMPPManager sharedInstance].xmppStream;
    XMPPJID *roomJID=[XMPPJID jidWithString:jidStr];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if (self.isOwner != 3) {
        [xmppRoom joinRoomUsingNickname:@"test11" history:nil];
    }
}

#pragma mark - 添加
-(void)rightBtnClick{
    if ([self.infoDic count]>0 && [[self.infoDic objectForKey:@"roomName"] length]>0) {
        RLGroupSetInfoVC * infoVC=[[RLGroupSetInfoVC alloc]initWithNibName:nil bundle:nil];
        infoVC.xmppRoom = xmppRoom;
        infoVC.roomJID=xmppRoom.roomJID;
        infoVC.roomSubject=xmppRoom.roomSubject;
        infoVC.isOwner = self.isOwner;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else{
        [[IMAlert alloc] alert:@"ID 不存在"];
    }


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark XMPPRoomStorage Protocol
- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    NSXMLElement *xmlGroupRole = [presence elementForName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    DDXMLNode *roleItem = [[xmlGroupRole elementForName:@"item"] attributeForName:@"role"];
    DDXMLNode *affiliationItem = [[xmlGroupRole elementForName:@"item"] attributeForName:@"affiliation"];
    NSString *groupRole = [roleItem stringValue];
    NSString *affiliationRole = [affiliationItem stringValue];
    if ([groupRole isEqualToString:@"participant"]) {
        if ([affiliationRole isEqualToString:@"owner"]) {
            self.isOwner = 0;
        }else if ([affiliationRole isEqualToString:@"member"])
        {
            self.isOwner = 2;
        }
    }else if ([groupRole isEqualToString:@"nono"])
    {
        self.isOwner = 3;
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

- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

@end
