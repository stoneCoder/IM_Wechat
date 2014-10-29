//
//  RLGroupListVC.m
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupListVC.h"
#import "RLGroupChatVC.h"
#import "RLGroupLogic.h"
#import "XMPPManager.h"
#import "RLGroupVO.h"
#import "RLRoom.h"
#import "RLSendMessageVC.h"
@interface RLGroupListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * roomList;
    BOOL  isFirstLoad;
    NSString * showMsg;
}
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) RLGroupLogic * logic;

@end
static NSString *listCellID = @"friendListCell";
@implementation RLGroupListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isFirstLoad) {
         [self getListDataWithPage];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeNaviLeftButtonVisible:YES];
    [self setTitleText:@"群"];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 88) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    UINib * cellNib=[UINib nibWithNibName:@"FriendListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:listCellID];
    
    [self.view addSubview:self.tableView];
    
    roomList=[[NSArray alloc]init];
    self.logic=[RLGroupLogic sharedRLGroupLogic];
    
    
    [self getListDataWithPage];
    
}
-(void)getListDataWithPage{
    XMPPJID * jid= [XMPPManager sharedInstance].xmppStream.myJID;
    [self.logic getGroupListByName:[jid bare] success:^(id json) {
        NSDictionary * dic=(NSDictionary *)json;
        roomList=[dic objectForKey:@"mucroomVos"];
        showMsg=[dic objectForKey:@"showMsg"];
        
        // 同步更新本地数据库
        [RLRoom syncRoomsWithArray:roomList];
        [self.tableView reloadData];
        isFirstLoad=YES;
    } failure:^(NSError *err) {
         [self failureHideHUD];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return roomList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID];
    NSMutableDictionary * roomDic=[roomList objectAtIndex:indexPath.row];
    RLGroupVO * groupVO=[[RLGroupVO alloc] initWithDictionary:roomDic];
    [cell updateCellWithGroupVO:groupVO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary * roomDic=[roomList objectAtIndex:indexPath.row];
    RLGroupVO * groupVO=[[RLGroupVO alloc] initWithDictionary:roomDic];
    RLSendMessageVC *sendMessageVC = [[RLSendMessageVC alloc] init];
    sendMessageVC.type = @"groupchat";
    sendMessageVC.friendJID = [XMPPJID jidWithString:groupVO.roomJid];
    sendMessageVC.badgeNum = -1;
    [self.navigationController pushViewController:sendMessageVC animated:YES];
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
