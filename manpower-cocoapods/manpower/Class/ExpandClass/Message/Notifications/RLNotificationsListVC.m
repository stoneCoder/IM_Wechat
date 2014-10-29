//
//  RLNotificationsListVC.m
//  manpower
//
//  Created by hanjin on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLNotificationsListVC.h"
#import "NotificationDataHelp.h"
#import "NotificationListCell.h"
#import "XMPPManager.h"
#import "RLTBC.h"
#import "AppDelegate.h"
#import "RLFriend.h"
#import "RLRoomLogic.h"
#import "RLMyInfo.h"
@interface RLNotificationsListVC ()<UITableViewDataSource,UITableViewDelegate,NotificationListCellDelegate>
{
    NSMutableArray * dataList;
    XMPPRoster * xmppRoster;
    XMPPManager * xmppManager;
    BOOL isLoad;
}
@property (strong, nonatomic)  UITableView *tableView;
@end
static NSString *listCellID = @"notificationListCell";

@implementation RLNotificationsListVC

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
    
    xmppManager=[XMPPManager sharedInstance];
    xmppRoster=xmppManager.xmppRoster;
    dataList=[[NotificationDataHelp  sharedNotificationDataHelp] currentNotificationList];
    
    CGRect frame=CGRectMake(0, 0, 320, self.view.bounds.size.height-94);
    if (iOS7) {
        frame=CGRectMake(0, 0, 320, self.view.bounds.size.height-114);
    }
    self.tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    UINib * cellNib=[UINib nibWithNibName:@"NotificationListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:listCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotificationData) name:@"NotificationRequest" object:nil];
    
}
-(void)reloadNotificationData{
    dataList=[[NotificationDataHelp  sharedNotificationDataHelp] currentNotificationList];
    [self.tableView reloadData];
    if (isLoad) {
        [self resetBadgeNum];
    }
}

/**
 *  功能: 清除tabbar通知的下标
 */

-(void)resetBadgeNum{
    int num=[[NotificationDataHelp sharedNotificationDataHelp] currentNotificationBadgeNum];
    AppDelegate * del=(AppDelegate *)[UIApplication sharedApplication].delegate;
    RLTBC * tbc=del.tabVC;
    int badgeNum=[[tbc currentBadgeNum] intValue]-num;
    [tbc setBadgeNum:[NSString stringWithFormat:@"%d",badgeNum]];
    [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationBadgeNum:0];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isLoad=NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    isLoad=YES;
    dataList=[[NotificationDataHelp  sharedNotificationDataHelp] currentNotificationList];
    [self.tableView reloadData];
    
    [self resetBadgeNum];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource  &&  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationRequest * aRequest=[dataList objectAtIndex:indexPath.row];
    NotificationListCell  * listCell=[tableView dequeueReusableCellWithIdentifier:listCellID];
    listCell.selectionStyle=UITableViewCellEditingStyleNone;
    listCell.index=indexPath.row;
    listCell.delegate=self;
    [listCell loadCellWithRequest:aRequest];
    return listCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationRequest * aRequest=[dataList objectAtIndex:indexPath.row];
    if (aRequest.requestType==1) {
        if (aRequest.acceptedState==0) {
            [xmppRoster unsubscribePresenceFromUser:aRequest.jid];
            [xmppRoster revokePresencePermissionFromUser:aRequest.jid];
            [xmppRoster removeUser:aRequest.jid];
        }
    }
    [dataList removeObject:aRequest];
    [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationList:dataList];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - NotificationListCellDelegate
-(void)refuseWithRequest:(NotificationRequest *)aRequest index:(int)aIndex{
    if (aRequest.requestType==1) {//好友
        [xmppRoster revokePresencePermissionFromUser:aRequest.jid];//撤销，废除,不会收到回执?
        [xmppRoster removeUser:aRequest.jid];//保险起见，防止挂起状态
        [dataList replaceObjectAtIndex:aIndex withObject:aRequest];
        [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationList:dataList];
        [self.tableView reloadData];
    } else {
        /*aRequest.jid 房间名 aRequest.name 被邀请人  aRequest.myJid 发送人*/
        NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
        NSXMLElement *decline = [NSXMLElement elementWithName:@"decline"];
        [decline addAttributeWithName:@"to" stringValue:[aRequest.myJid full]];
        if ([aRequest.reasonStr length] > 0)
        {
            [decline addChild:[NSXMLElement elementWithName:@"reason" stringValue:aRequest.reasonStr]];
        }
        [x addChild:decline];
        XMPPMessage *message = [XMPPMessage message];
        [message addAttributeWithName:@"to" stringValue:[aRequest.jid full]];
        [message addAttributeWithName:@"from" stringValue:aRequest.name];

        [message addChild:x];
        [[XMPPManager sharedInstance].xmppStream sendElement:message];
        
        [dataList replaceObjectAtIndex:aIndex withObject:aRequest];
        [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationList:dataList];
        [self.tableView reloadData];
    }
    
}
-(void)agreeWithRequest:(NotificationRequest *)aRequest index:(int)aIndex{
    if (aRequest.requestType==1) {//好友
        [xmppManager acceptPresenceSubscriptionRequestFrom:aRequest.jid andAddToRoster:YES];//同意，发送subscribed
        [RLFriend asyncFriendWidthJIDStr:aRequest.jid.user];
        [dataList replaceObjectAtIndex:aIndex withObject:aRequest];
        [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationList:dataList];
        [self.tableView reloadData];
    }else{
        //加群
        [[RLGroupLogic sharedRLGroupLogic] joinGroupByUserJID:[aRequest.myJid full] andRoomName:[[aRequest.jid user] lowercaseString] success:^(id json) {
            NSDictionary * dic=(NSDictionary *)json;
            if (dic.count > 0) {
                NSString *showMsg = nil;
                if ([dic objectForKey:@"showMsg"] == 0) {
                    showMsg = @"false";
                }else
                {
                    showMsg = @"true";
                }
                NSString *successMsg = [dic objectForKey:@"message"];
                if ([showMsg isEqualToString:@"true"] && [successMsg isEqualToString:@"SUCCESS"]) {
                    // 设置群昵称
                    [RLRoomLogic changeNickname:[RLMyInfo sharedRLMyInfo].name withUserJIDStr:xmppManager.xmppStream.myJID.bare withRoomName:aRequest.jid.user];
                    
                    [self showStringHUD:@"加群成功\n" second:2];
                    [dataList replaceObjectAtIndex:aIndex withObject:aRequest];
                    [[NotificationDataHelp sharedNotificationDataHelp] saveNotificationList:dataList];
                    [self.tableView reloadData];
                    return;
                }else
                {
                    [self showStringHUD:successMsg second:2];
                    return;
                }
            }else
            {
                [self showStringHUD:@"服务器异常，稍后再试" second:2];
            }
        } failure:^(NSError *err) {
            [self failureHideHUD];
        }];
    }

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

@end
