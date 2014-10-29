//
//  RLGroupInviteVC.m
//  manpower
//
//  Created by hanjin on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupInviteVC.h"
#import "XMPPManager.h"
@interface RLGroupInviteVC ()

@end

@implementation RLGroupInviteVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[XMPPManager sharedInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeNaviLeftButtonVisible:YES];

    [self setTitleText:@"邀请成员"];

    XMPPRoom * room=[XMPPManager sharedInstance].currentJoinedRoom;
    XMPPJID * toJid=[XMPPJID jidWithString:@"hanjin2@hanmin"];
    [room inviteUser:toJid withMessage:@"加进来吗？"];
}
//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
