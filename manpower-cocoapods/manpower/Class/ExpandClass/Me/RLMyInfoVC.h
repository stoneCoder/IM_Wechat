//
//  RLMyInfo.h
//  manpower
//
//  Created by WangShunzhou on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseTableVC.h"
@class XMPPManager;
@class RLMyInfoHeaderView;

@interface RLMyInfoVC : RLBaseTableVC{
    XMPPManager *xmpp;
}
@property (strong,nonatomic) RLMyInfoHeaderView * headerView;

@end