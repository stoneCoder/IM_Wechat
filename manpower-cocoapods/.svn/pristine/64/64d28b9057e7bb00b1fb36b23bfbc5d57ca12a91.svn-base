//
//  FriendListCell.h
//  manpower
//
//  Created by hanjin on 14-6-18.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"
#import "RLGroupVO.h"
@interface FriendListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (strong,nonatomic) UIImageView * selectImageView;
@property (assign,nonatomic) BOOL isSelected;
-(void)updateCellWithUserStorage:(XMPPUserCoreDataStorageObject *)aUser;

-(void)updateCellWithGroupVO:(RLGroupVO *)rlGroupVO;

-(void)updateGroupAddCellWithUserStorage:(XMPPUserCoreDataStorageObject *)aUser;

@end
