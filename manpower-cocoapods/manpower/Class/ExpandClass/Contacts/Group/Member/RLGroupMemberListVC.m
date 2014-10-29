//
//  RLGroupMemberListVC.m
//  manpower
//
//  Created by hanjin on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupMemberListVC.h"
#import "RLMemberVO.h"
#import "XMPPManager.h"
#import "RLGroupMemberInfoVC.h"
#import "IMLabel.h"

#import "RLPersonLogic.h"
#import "RLFriend.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RLGroupMemberListVC ()<UITableViewDataSource,UITableViewDelegate>{
    RLFriend *friend;
}
@property (strong,nonatomic) UITableView * tableView;
@end

enum{
    kPhotoCellImageView = 100,
    kUsernameLabel = 101,
};

static UIImage *kDefaultPhoto;

@implementation RLGroupMemberListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self makeNaviLeftButtonVisible:YES];
        self.xmpp = [XMPPManager sharedInstance];
        self.logic = [RLGroupLogic sharedRLGroupLogic];
        kDefaultPhoto = IMAGE_DEFAULT_PERSON;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleText:@"成员"];
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 28, 28);
    [rightBtn setImage:[UIImage imageNamed:@"btn-add-member"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn-add-member-sel"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;
    
    if (self.isOwner == 2) {
        rightBtn.hidden = YES;
    }
    [self.view addSubview:self.tableView];

    [self getListDataWithPage];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self getListDataWithPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getListDataWithPage{
    [self showHUD];
    [self.logic getMemberListByGroupName:self.xmppRoom.roomJID.user success:^(id json) {
        [self hideHUD];
        NSDictionary * dic=(NSDictionary *)json;
        self.memberList = (NSArray *)[dic objectForKey:@"roomUsers"];
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        [self failureHideHUD];
    }];
}

-(void)infoBtnClick:(id)sender
{
    RLInviteIntoRoomVC *inviteInRoomVc = [[RLInviteIntoRoomVC alloc] init];
    inviteInRoomVc.xmppRoom = self.xmppRoom;
    inviteInRoomVc.groupFriendsArray = self.memberList;
    [self.navigationController pushViewController:inviteInRoomVc animated:YES];
}
#pragma mark -UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memberList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *photoIV;
    UILabel *usernameLabel;
    static NSString *CellIdentifier = @"Cell";
    /*获取JID*/
    NSMutableDictionary * member=[self.memberList objectAtIndex:indexPath.row];
    RLMemberVO * memberVO=[[RLMemberVO alloc]initWithDictionary:member];
    XMPPJID * jid=[XMPPJID jidWithString:memberVO.jid];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        photoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        photoIV.tag = kPhotoCellImageView;
        
        usernameLabel = [IMLabel labelWithTitle:[NSString stringWithFormat:@"%@",jid.user]];
        usernameLabel.tag = kUsernameLabel;
        [usernameLabel setFrame:CGRectMake(70, 15, 200, 20)];
        [cell.contentView addSubview:photoIV];
        [cell.contentView addSubview:usernameLabel];
	}else
    {
        photoIV = (UIImageView*)[cell.contentView viewWithTag:kPhotoCellImageView];
        usernameLabel = (UILabel*)[cell.contentView viewWithTag:kUsernameLabel];
    }
    
    NSURL *url = [NSURL URLWithString:memberVO.photo];
    [photoIV sd_setImageWithURL:url placeholderImage:kDefaultPhoto];
    photoIV.layer.cornerRadius = photoIV.frame.size.width * 0.5;
    photoIV.layer.masksToBounds = YES;
    
    cell.imageView.backgroundColor=[UIColor redColor];
    if (memberVO.online.intValue==0) {//离线
        cell.textLabel.textColor=[UIColor lightGrayColor];
    } else {//在线
        cell.textLabel.textColor=[UIColor blackColor];
    }
    usernameLabel.text= memberVO.nickName.length?memberVO.nickName: jid.user;
    [usernameLabel sizeToFit];

    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (memberVO.affiliation.intValue==10) {
        cell.detailTextLabel.text=@"管理员";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary * member=[self.memberList objectAtIndex:indexPath.row];
    NSString *jid = [member objectForKey:@"jid"];
//    if (![jid isEqualToString:[self.xmpp.xmppStream.myJID bare]]) {
        __block XMPPRoom *weakXmppRoom = self.xmppRoom;
        __block NSMutableDictionary *blockMember = member;
        NSRange range = [jid rangeOfString:@"@"];
        if (range.length > 0) {
            NSString *userName = [jid componentsSeparatedByString:@"@"][0];
            [RLPersonLogic getPersonInfoWithUsername:userName withView:nil
                                             success:^(id responseObject){
                                                 friend = [RLFriend MR_createEntity];
                                                 [friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]];
                                                 
                                                 RLGroupMemberInfoVC * infoVC=[[RLGroupMemberInfoVC alloc]initWithNibName:nil bundle:nil];
                                                 infoVC.isOwner = self.isOwner;
                                                 infoVC.xmppRoom = weakXmppRoom;
                                                 infoVC.memberVO= [[RLMemberVO alloc] initWithDictionary:blockMember];
                                                 infoVC.friendInfo = friend;
                                                 infoVC.nickname = [member objectForKey:@"nickName"];
                                                 [self.navigationController pushViewController:infoVC animated:YES];
                                             } failure:NULL];
        }
        
//    }
}

-(void)createFriendEntity:(NSString *)username
{
    
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
-(void)dealloc{
    [friend MR_deleteEntity];
    friend = nil;
}
@end
