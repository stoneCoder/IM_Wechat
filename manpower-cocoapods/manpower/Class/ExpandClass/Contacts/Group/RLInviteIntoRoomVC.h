//
//  RLFrendListVC.h
//  manpower
//
//  Created by hanjin on 14-6-3.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLBaseVC.h"
#import <CoreData/CoreData.h>
#import "XMPPManager.h"
#import "FriendSectionView.h"

@interface RLInviteIntoRoomVC : RLBaseVC
@property (strong,nonatomic) XMPPRoom *xmppRoom;
@property (strong,nonatomic) NSMutableDictionary *canInviteFriendsArray; //邀请好友进群
@property (strong,nonatomic) NSArray *groupFriendsArray;
@end
