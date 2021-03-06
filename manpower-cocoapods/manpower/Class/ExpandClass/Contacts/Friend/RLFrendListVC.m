//
//  RLFrendListVC.m
//  manpower
//
//  Created by hanjin on 14-6-3.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFrendListVC.h"
#import "XMPPFramework.h"
#import "XMPPManager.h"
#import "DDLog.h"
#import "RLSendMessageVC.h"
#import "FriendSectionView.h"
#import "RLFriendGroupManageVC.h"
#import "IMAlert.h"
#import "FriendDataHelp.h"
#import "FriendListCell.h"
#import "RLGroupListVC.h"
#import "PopoverView.h"
@interface RLFrendListVC ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,FriendSectionViewDelegate,PopoverViewDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
    NSMutableArray * dataAry;//好友
    NSMutableArray * noGroupAry;//没有分组的好友
    NSMutableArray * sectionModelList;//section分组信息列表
    int type;
    int selectedSectionIndex;//选中的section
    
    SectionInfoModel * defaultModel;//默认分组：我的好友
}
@property (strong,nonatomic)  UITableView *tableView;
@property (strong,nonatomic)   NSMutableArray * userAry;//所有好友
@property (strong,nonatomic) NSMutableArray * friendGroupList;//好友分组
@end
static NSString *listCellID = @"friendListCell";
static NSString *sectionID = @"friendSection";

@implementation RLFrendListVC

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
    [self makeNaviLeftButtonVisible:YES];

    //初始化ui
    [self initUI];
    
    selectedSectionIndex=-1;
    dataAry=[[NSMutableArray alloc]init];
    sectionModelList=[[NSMutableArray alloc]init];
    
    [self refishDataList];
   
}




/**
 *  功能:初始化ui
 */

-(void)initUI{
    CGRect tableviewFrame=self.view.bounds;
    if (iOS7) {
         tableviewFrame.size.height-=64;
    } else {
        tableviewFrame.size.height-=90;

    }
   
    self.tableView=[[UITableView alloc]initWithFrame:tableviewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    CGRect bgFrame=CGRectMake(0, 0, 320, 49);
    if (iOS7) {
        bgFrame=headerView.bounds;
    }
    UIImageView * bgImageView=[[UIImageView alloc]initWithFrame:bgFrame];
    [bgImageView setImage:[UIImage imageNamed:@"friendlist_cell_bg"]];
    [headerView addSubview:bgImageView];
    
    UIImageView * groupImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20,5,36,36)];
    [groupImageView setImage:[UIImage imageNamed:@"groups_icon"]];
    [headerView addSubview:groupImageView];
    
    UILabel * titleLab=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 40, 20)];
    titleLab.backgroundColor=[UIColor clearColor];
    titleLab.font=[UIFont systemFontOfSize:14.0];
    titleLab.text=@"群";
    [headerView addSubview:titleLab];
    
    UITapGestureRecognizer * tuch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchInheaderView)];
    [headerView addGestureRecognizer:tuch];
    
    self.tableView.tableHeaderView=headerView;
    
    
    [self.view addSubview:self.tableView];
    UINib * cellNib=[UINib nibWithNibName:@"FriendListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:listCellID];
    
    [self.tableView registerClass:[FriendSectionView class] forHeaderFooterViewReuseIdentifier:sectionID];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refishDataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"nickname" ascending:YES];
		NSSortDescriptor *sd3 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,sd2,sd3, nil];
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

/**
 *  功能:群组
 */
-(void)tuchInheaderView{
    RLGroupListVC * groupListVC=[[RLGroupListVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:groupListVC animated:YES];
}

/**
 *  功能:初始化并刷新
 */

-(void)refishDataList{
    self.friendGroupList=[[FriendDataHelp sharedFriendDataHelp] friendGroupList];//获取分组名
    [self getDataList];//获取分组下面的好友
}

/**
 *  功能:获取分组下面的好友
 */
-(void)getDataList{
    
    selectedSectionIndex=-1;
    
    self.friendGroupList=[FriendDataHelp sharedFriendDataHelp].groupList;
    NSArray * userAry=[[self fetchedResultsController] fetchedObjects];
    [dataAry removeAllObjects];
    if (userAry && userAry.count>0) {
        /*
        noGroupAry=[[NSMutableArray alloc]init];
        //没有分组的
        for (XMPPUserCoreDataStorageObject *user in userAry) {
            if ([user.subscription isEqualToString:@"both"]) {
                NSArray * groupAry=user.groups.allObjects;
                if ( !groupAry  || groupAry.count==0){
                    
                    [noGroupAry addObject:user];
                }
            }
        }
        
        [dataAry addObject:noGroupAry];//section==0 时为无分组的好友
         */
        //有分组的
        for (SectionInfoModel * model in self.friendGroupList) {
//            XMPPGroupCoreDataStorageObject *group = [XMPPGroupCoreDataStorageObject fetchOrInsertGroupName:model.name inManagedObjectContext:[[XMPPManager sharedInstance] managedObjectContext_roster]];
//            [dataAry addObject:group.users];
            
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

            [dataAry addObject:rowAry];
            
           
            
        }
        
        
    }
    
    
    if (dataAry && dataAry.count>0) {
        for (int i=1; i<dataAry.count-1; i++) {
            
            if ([[dataAry objectAtIndex:i] count]==0) {
                [dataAry removeObjectAtIndex:i];
                [self.friendGroupList removeObjectAtIndex:i-1];
            }
        }
    }
   
    
    
    
    [sectionModelList removeAllObjects];
    if (sectionModelList.count==0) {
//        if (!defaultModel) {
//            defaultModel=[[SectionInfoModel alloc]init];
//            defaultModel.name = kDefaultGroupName;
//        }
//        [sectionModelList addObject:defaultModel];
        [sectionModelList  addObjectsFromArray:self.friendGroupList];
        
    }

       [[self tableView] reloadData];
}
/**
 *  功能:获取在线人数
 */

-(int)getOnlineNumWithSection:(int)section{
    int onlineNum=0;
    if (dataAry && dataAry.count>0) {
        NSArray * userAry=[dataAry objectAtIndex:section];
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
    FriendSectionView * sectionView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
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
        return 50;
    } else {
        return 0;
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
    FriendListCell * listCell=[tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    listCell.selectionStyle=UITableViewCellSelectionStyleNone;
    [listCell updateCellWithUserStorage:user];
    
    return listCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    XMPPUserCoreDataStorageObject *user=[[dataAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    RLSendMessageVC *sendMessageVC = [[RLSendMessageVC alloc] init];
    sendMessageVC.friendJID = user.jid;
    sendMessageVC.type = @"chat";
    sendMessageVC.badgeNum = -1;
    [self.navigationController pushViewController:sendMessageVC animated:YES];
}

#pragma mark -FriendListSecionViewDelegate
//长按
-(void)longTuchInSecionView:(FriendSectionView *)aSectionView{
    CGPoint point=CGPointMake(CGRectGetMidX(aSectionView.frame), CGRectGetMinY(aSectionView.frame));
    [PopoverView showPopoverAtPoint:point inView:self.tableView withText:@"管理分组" delegate:self];
}
//点击
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

#pragma mark - PopoverViewDelegate
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index{
    RLFriendGroupManageVC * manageVC=[[RLFriendGroupManageVC alloc]initWithNibName:nil bundle:nil];
    manageVC.friendList=dataAry;
    manageVC.userList=[[self fetchedResultsController] fetchedObjects];
    [self.navigationController pushViewController:manageVC animated:YES];
    [popoverView dismiss:YES];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView{

}


@end
