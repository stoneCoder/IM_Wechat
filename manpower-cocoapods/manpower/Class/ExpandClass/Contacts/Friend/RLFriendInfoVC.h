//
//  RLFriendInfoVC.h
//  manpower
//
//  Created by Brian on 14-6-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseTableVC.h"
#import "GroupInfoHeadView.h"
#import "XMPPManager.h"
#import "RLSectionGroupVC.h"
#import "RLInfoCell.h"
#import "IMAlert.h"
#import "RLSendMessageVC.h"
@class RLFriend;

@interface RLFriendInfoVC : RLBaseTableVC
//@property (strong,nonatomic) UITableView * tableView;
@property (strong, nonatomic) XMPPJID *friendJID;
@property (strong,nonatomic) XMPPManager *xmpp;
@property (strong,nonatomic) XMPPUserCoreDataStorageObject *friendInfo;
@property (strong,nonatomic) UIButton *deleteButton;
@property (strong,nonatomic) UIButton *sendButton;
@property (strong,nonatomic) UIButton *addButton;
@property (strong,nonatomic) NSString *sectionName;
@property (strong,nonatomic) NSString *nickName;
@property (strong,nonatomic) RLFriend * friend;
//
//@property (strong,nonatomic) RLInfoCell *nickNameCell;
//@property (strong,nonatomic) RLInfoCell *groupCell;
//@property (strong,nonatomic) RLInfoCell *remarkCell;
//@property (strong,nonatomic) GroupInfoHeadView * headerView;

@property (assign,nonatomic) int backFlag;
@end
