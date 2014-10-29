//
//  RLFriendGroupManageVC.m
//  manpower
//
//  Created by hanjin on 14-6-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFriendGroupManageVC.h"
#import "XMPPFramework.h"
#import "XMPPManager.h"
#import "DDLog.h"
#import "FriendDataHelp.h"
#import "SectionInfoModel.h"
#import "RLFriendGroupAddVC.h"
@interface RLFriendGroupManageVC ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSString * createdGroupName;//新建分组名
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * friendGroupList;
@end

@implementation RLFriendGroupManageVC

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
    
    [self makeNaviLeftButtonVisible:YES];

    self.navigationController.navigationBar.translucent = NO;
    [self setTitleText:@"分组管理"];
    
    //分组
    self.friendGroupList=[[FriendDataHelp sharedFriendDataHelp] friendGroupList];
    if (self.friendGroupList==nil) {
        self.friendGroupList=[[NSMutableArray alloc]init];
    }
    
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendGroupList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionInfoModel * model=(SectionInfoModel *)[self.friendGroupList objectAtIndex:indexPath.row];
    UILabel * titleLab;
    UIButton * deleteBtn;
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(40, 17, 100, 20)];
    titleLab.font=[UIFont systemFontOfSize:16.0];
    titleLab.textColor=[UIColor blackColor];
    titleLab.text=model.name;
    [cell.contentView addSubview:titleLab];
    
    if (![model.name isEqualToString:kDefaultGroupName]) {
        deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame=CGRectMake(280, 17, 20, 20);
        [deleteBtn setImage:[UIImage imageNamed:@"friend_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deletaGroup:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag=indexPath.row;
        [cell.contentView addSubview:deleteBtn];
    }

    
    UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, 54, 320, 1)];
    line.backgroundColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:line];

	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


#pragma mark - 功能
/**
 *  功能:删除分组
 */
-(void)deleteGroupWithIndex:(int)index{
     SectionInfoModel * model=(SectionInfoModel *)[self.friendGroupList objectAtIndex:index];
    NSString * groupName=model.name;
    if ([groupName isEqualToString:kDefaultGroupName]) {
        [self showStringHUD:@"默认分组无法被删除" second:1.25];
        return;
    }
    if (self.userList && self.userList.count>0) {
        for (XMPPUserCoreDataStorageObject *user in self.userList) {
            if ([user.subscription isEqualToString:@"both"]) {//好友
                NSArray * groupAry=user.groups.allObjects;
                if (groupAry && groupAry.count>0) {
                    XMPPGroupCoreDataStorageObject * group=[user.groups.allObjects objectAtIndex:0];
                    if (group && [group.name isEqualToString:groupName]) {
                        [[[XMPPManager sharedInstance] xmppRoster] addUser:user.jid withNickname:user.nickname groups:@[kDefaultGroupName] subscribeToPresence:NO];
                    }
                }
            }else{//挂起或其他状态
                [[[XMPPManager sharedInstance] xmppRoster] unsubscribePresenceFromUser:user.jid];
                [[[XMPPManager sharedInstance] xmppRoster] revokePresencePermissionFromUser:user.jid];
                [[[XMPPManager sharedInstance] xmppRoster] removeUser:user.jid];
            }
        }

    
    }
    [self.friendGroupList removeObjectAtIndex:index];
    NSManagedObjectContext *moc = [[XMPPManager sharedInstance] managedObjectContext_roster];
    XMPPGroupCoreDataStorageObject * group = [XMPPGroupCoreDataStorageObject fetchOrInsertGroupName:groupName inManagedObjectContext:moc];
    [moc deleteObject:group];
    [moc save:nil];
    
    
//    [FriendDataHelp sharedFriendDataHelp].groupList=self.friendGroupList;
}

#pragma mark - IBAction
-(void)deletaGroup:(UIButton *)aBtn{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:aBtn.tag inSection:0];
    [self deleteGroupWithIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];

}
- (IBAction)addGroupClick:(id)sender {
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"添加分组" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.delegate=self;
    alert.tag=0;
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    createdGroupName=tf.text;
    //添加分组
    //确定,是否要屏蔽掉分组名字为空格（空）的情况
    if (buttonIndex==1) {
        if (createdGroupName.length>0) {
            BOOL isHaved=NO;
            //判断是否已存在分组中
            for (SectionInfoModel * model in [FriendDataHelp sharedFriendDataHelp].groupList) {
                if ([model.name isEqualToString:createdGroupName]) {
                    isHaved =YES;
                }
            }
            if ([createdGroupName isEqualToString:kDefaultGroupName]) {
                isHaved =YES;
            }
            if (isHaved) {
                [self showStringHUD:@"您已经存在该分组" second:1.0];
            } else {
                RLFriendGroupAddVC * addVC=[[RLFriendGroupAddVC alloc]initWithNibName:nil bundle:nil];
                addVC.groupName=createdGroupName;
                addVC.friendList=self.userList;
                [self.navigationController pushViewController:addVC animated:YES];
            }
        } else {
            [self showStringHUD:@"分组名不能为空" second:1.0];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
