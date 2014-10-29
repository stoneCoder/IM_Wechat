//
//  RLFrendListVC.m
//  manpower
//
//  Created by hanjin on 14-6-3.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//
#import "RLInviteIntoRoomVC.h"
#import "XMPPFramework.h"
#import "XMPPManager.h"
#import "DDLog.h"
#import "RLSendMessageVC.h"
#import "RLFriendGroupManageVC.h"
#import "IMAlert.h"
#import "FriendDataHelp.h"
#import "FriendListCell.h"
#import "RLGroupListVC.h"
@interface RLInviteIntoRoomVC()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,FriendSectionViewDelegate,UIAlertViewDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
    NSMutableArray * dataAry;//好友
    NSMutableArray * noGroupAry;//没有分组的好友
    NSMutableArray * sectionModelList;
    BOOL isFirstLoad;
    int type;
    int selectedSectionIndex;//选中的section
}
@property (strong,nonatomic)  UITableView *tableView;
@property (strong,nonatomic)   NSMutableArray * userAry;//所有好友
@property (strong,nonatomic) NSMutableArray * friendGroupList;//好友分组


@end
static NSString *listCellID = @"friendListCell";
static NSString *sectionID = @"friendSection";

@implementation RLInviteIntoRoomVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleText:@"邀请好友"];
        self.groupFriendsArray = [[NSArray alloc] init];
        self.canInviteFriendsArray = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNaviLeftButtonVisible:YES];
    
    CGRect tableviewFrame=self.view.bounds;
    if (!iOS7) {
        tableviewFrame.size.height-=90;
    }
    self.tableView=[[UITableView alloc]initWithFrame:tableviewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 54, 28)];
    [rightBtn setImage:[UIImage imageNamed:@"btn_done"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_done_sel"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(inviteSomeBodyIntoRoom:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;
  
    [self.view addSubview:self.tableView];
    UINib * cellNib=[UINib nibWithNibName:@"FriendListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:listCellID];
    
    [self.tableView registerClass:[FriendSectionView class] forHeaderFooterViewReuseIdentifier:sectionID];
    
    dataAry=[[NSMutableArray alloc]init];
    self.friendGroupList=[[FriendDataHelp sharedFriendDataHelp] friendGroupList];//获取分组名
    isFirstLoad=NO;
    sectionModelList=[[NSMutableArray alloc]init];
    [self getDataList];//获取分组下面的好友
}

/**
 *  功能:获取分组下面的好友
 */

-(void)getDataList{
    isFirstLoad=YES;
    selectedSectionIndex=-1;
    self.friendGroupList=[[FriendDataHelp sharedFriendDataHelp] friendGroupList];
    [sectionModelList removeAllObjects];
    
    if (sectionModelList.count==0) {
//        SectionInfoModel * model=[[SectionInfoModel alloc]init];
//        model.isSelected = NO;
//        model.name=kDefaultGroupName;
//        [sectionModelList addObject:model];
        [sectionModelList  addObjectsFromArray:self.friendGroupList];
    }
    
    NSArray * userAry=[[self fetchedResultsController] fetchedObjects];
    [dataAry removeAllObjects];
    if (userAry && userAry.count>0) {
        //没有分组的
//        noGroupAry=[[NSMutableArray alloc]init];
//        for (XMPPUserCoreDataStorageObject *user in userAry) {
//            if ([user.subscription isEqualToString:@"both"]) {
//                NSArray * groupAry=user.groups.allObjects;
//                if ( !groupAry  || groupAry.count==0){
//                    [noGroupAry addObject:user];
//                }
//            }
//        }
//        [self checkExcitUserWithArray:noGroupAry];
//        [dataAry addObject:noGroupAry];
        //有分组的
        for (SectionInfoModel * model in self.friendGroupList) {
             NSMutableArray * rowAry=[[NSMutableArray alloc]init];
            for (XMPPUserCoreDataStorageObject *user in userAry) {
                if ([user.subscription isEqualToString:@"both"]) {
                    NSArray * groupAry=user.groups.allObjects;
                    if (groupAry && groupAry.count>0) {
                        XMPPGroupCoreDataStorageObject * group=[user.groups.allObjects objectAtIndex:0];
                        if (group && [group.name isEqualToString:model.name]) {
                            [rowAry addObject:user];
                        }
                    }
                }
            }
            [self checkExcitUserWithArray:rowAry];
            [dataAry addObject:rowAry];
        }
    }
    
    [[self tableView] reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    if (isFirstLoad) {
        [self getDataList];
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)checkExcitUserWithArray:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
        XMPPUserCoreDataStorageObject *inviteUser = array[i];
        for (int j = 0; j < self.groupFriendsArray.count; j++) {
            if ([inviteUser.jidStr isEqualToString:[self.groupFriendsArray[j] objectForKey:@"jid"]]) {
                [array removeObjectAtIndex:i];
            }
        }
    }
    return array;
}
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[XMPPManager sharedInstance] managedObjectContext_roster];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        // NSSortDescriptor *sd3 = [[NSSortDescriptor alloc] initWithKey:@"nickname" ascending:YES];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd2, nil];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
	}
	return fetchedResultsController;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self getDataList];
}
#pragma mark - 功能
-(int)getOnlineNumWithSection:(int)section{
    int onlineNum=0;
    if (dataAry && dataAry.count>0) {
        NSArray * userAry= [dataAry objectAtIndex:section];
        for (XMPPUserCoreDataStorageObject *user in userAry) {
            if (user.sectionNum.intValue==0 || user.sectionNum.intValue==1) {
                onlineNum++;
            }
        }
    }
    return onlineNum;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionModelList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    int totalNum=0;
    if (dataAry && dataAry.count>0) {
        totalNum=[[dataAry objectAtIndex:section] count];
    }
    int onlineNum=[self getOnlineNumWithSection:section];
    NSString * numInfo=[NSString stringWithFormat:@"%d/%d",onlineNum,totalNum];
    FriendSectionView * sectionView=[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    sectionView.index=section;
    sectionView.delegate=self;
    SectionInfoModel * model=(SectionInfoModel *)[sectionModelList objectAtIndex:section];
    [sectionView loadViewWithSectionModel:model numInfo:numInfo];
	return sectionView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionInfoModel * infoModel=(SectionInfoModel *)[sectionModelList objectAtIndex:indexPath.section];
    if (infoModel.isSelected) {
        return 50.0f;
    } else {
        return 0.0f;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    SectionInfoModel * infoModel=(SectionInfoModel *)[sectionModelList objectAtIndex:sectionIndex];
    if (infoModel.isSelected) {
        if (dataAry && dataAry.count>0) {
            return [[dataAry objectAtIndex:sectionIndex] count];
        }
    } else {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *user=[[dataAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *jidStr = user.jidStr;
    FriendListCell * listCell=[tableView dequeueReusableCellWithIdentifier:listCellID];
    [listCell updateGroupAddCellWithUserStorage:user];
    for (int i = 0; i < [[self.canInviteFriendsArray allKeys] count]; i++) {
        if ([[self.canInviteFriendsArray allKeys][i] isEqualToString:jidStr]) {
             listCell.isSelected=YES;
            [listCell.selectImageView setImage:[UIImage imageNamed:@"group_add_sel"]];
        }
    }
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return listCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     XMPPUserCoreDataStorageObject *user= [[dataAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    FriendListCell * cell=(FriendListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        cell.isSelected=NO;
        [cell.selectImageView setImage:[UIImage imageNamed:@"group_add"]];
        [self.canInviteFriendsArray removeObjectForKey:user.jidStr];
    } else {
        cell.isSelected=YES;
        [cell.selectImageView setImage:[UIImage imageNamed:@"group_add_sel"]];
        [self.canInviteFriendsArray setObject:user forKey:user.jidStr];
    }
   
    
}

#pragma mark -FriendListSecionViewDelegate
-(void)clickSectionView:(int)index{
    SectionInfoModel * model=[sectionModelList objectAtIndex:index];
    if (model.isSelected) {
        model.isSelected=NO;
    } else {
        model.isSelected=YES;
    }
    if (selectedSectionIndex!=index) {
        //刷新ui
        int lastExpandIndex = selectedSectionIndex;
        selectedSectionIndex=index;
        if (lastExpandIndex!=-1) {
            NSMutableIndexSet *mIndexSet = [NSMutableIndexSet indexSetWithIndex:lastExpandIndex];
            [mIndexSet addIndex:index];
            [self.tableView reloadSections:mIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSMutableIndexSet *mIndexSet = [NSMutableIndexSet indexSetWithIndex:index];
            [self.tableView reloadSections:mIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        //偏移
        // [self.tableView setContentOffset:CGPointMake(0, 44.0*index) animated:YES];
    } else {
        selectedSectionIndex=-1;
        NSMutableIndexSet *mIndexSet = [NSMutableIndexSet indexSetWithIndex:index];
        [self.tableView reloadSections:mIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
    
}

-(void)inviteSomeBodyIntoRoom:(UIButton *)sender
{
    if ([self.canInviteFriendsArray count] != 0) {
        NSArray *keysArray = [self.canInviteFriendsArray allKeys];
        for (int i = 0; i < keysArray.count; i++) {
            XMPPUserCoreDataStorageObject *user = [self.canInviteFriendsArray objectForKey:keysArray[i]];
            [self.xmppRoom inviteUser:user.jid withMessage:@"加进来吗？"];
        }
        [[IMAlert alloc] alert:@"请求已发出" delegate:self];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
