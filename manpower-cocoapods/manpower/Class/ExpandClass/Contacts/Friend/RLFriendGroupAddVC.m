//
//  RLFriendGroupAddVC.m
//  manpower
//
//  Created by hanjin on 14-6-27.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFriendGroupAddVC.h"
#import "FriendListCell.h"
#import "IMAlert.h"
#import "SectionInfoModel.h"
#import "FriendDataHelp.h"
@interface RLFriendGroupAddVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * selectedFriendList;//选中好友
}
@property (strong,nonatomic)  UITableView *tableView;
@end
static NSString *listCellID = @"friendListCell";

@implementation RLFriendGroupAddVC

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
     [self makeNaviLeftButtonVisible:YES];
    [self setTitleText:@"选择联系人"];
    
    selectedFriendList=[[NSMutableArray alloc]init];
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 54, 28)];
    [rightBtn setImage:[UIImage imageNamed:@"btn_done"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_done_sel"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;

    CGRect tableviewFrame=self.view.bounds;
    if (iOS7) {
        tableviewFrame.size.height+=20;
    }{
     tableviewFrame.size.height-=90;
    }
    self.tableView=[[UITableView alloc]initWithFrame:tableviewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
  
    UINib * cellNib=[UINib nibWithNibName:@"FriendListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:listCellID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//完成
-(void)rightBtnClick{

    if (selectedFriendList && selectedFriendList.count>0) {
        for (NSString * userName in selectedFriendList) {
            [[XMPPManager sharedInstance] AddFriendWith:userName andGroup:self.groupName];
        }
        SectionInfoModel * model=[[SectionInfoModel alloc]init];
        model.name=self.groupName;
        [[FriendDataHelp sharedFriendDataHelp].friendGroupList addObject:model];
        [self showStringHUD:@"创建成功" second:1.0];
    }else{
        [[IMAlert alloc]alert:@"请选择好友" delegate:self];
    }
}

-(void)hideHUD{
    [self.navigationController popToRootViewControllerAnimated:YES ];
    [super hideHUD];
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.friendList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     XMPPUserCoreDataStorageObject *user=[self.friendList objectAtIndex:indexPath.row];
    FriendListCell * cell=[tableView dequeueReusableCellWithIdentifier:listCellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell updateGroupAddCellWithUserStorage:user];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject *user=[self.friendList objectAtIndex:indexPath.row];
    NSString * userName=user.jid.user;
    FriendListCell * cell=(FriendListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        cell.isSelected=NO;
        [cell.selectImageView setImage:[UIImage imageNamed:@"group_add"]];
        [selectedFriendList removeObject:userName];

    } else {
        cell.isSelected=YES;
        [cell.selectImageView setImage:[UIImage imageNamed:@"group_add_sel"]];
        [selectedFriendList addObject:userName];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
