//
//  RLSearchFriendResault.m
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLSearchFriendResault.h"
#import "FriendInfoView.h"
#import "XMPPManager.h"
#import "IMAlert.h"
#import "FriendDataHelp.h"
#import "SectionInfoModel.h"
#import "GroupInfoHeadView.h"
#import "NSData+XMPP.h"
#import <CoreGraphics/CoreGraphics.h>
#import "RLSectionGroupVC.h"
@interface RLSearchFriendResault ()<UITableViewDataSource,UITableViewDelegate>
{
    GroupInfoHeadView * headerView;
}
@property (strong,nonatomic) UITableView * tableView;

@end

@implementation RLSearchFriendResault

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

    
    [self setTitleText:@"个人资料"];
    
    CGRect tableRect=CGRectMake(0, 0, 320, 400);
    
    self.tableView=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    headerView=[[GroupInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];

    self.tableView.tableHeaderView=headerView;
    [self.view addSubview:self.tableView];

    UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 80)];
    UIButton * btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,20, 300, 44);
    btn.backgroundColor=[UIColor redColor];
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:17.0];
    btn.layer.cornerRadius=5.0;
    [btn setTitle:@"添加好友" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
   
    [footView addSubview:btn];
    self.tableView.tableFooterView=footView;
    
//    [self addInfoView];
   
}



/**
 *  功能:添加
 */

-(void)rightBtnClick{
    RLSectionGroupVC * selectGroupVC=[[RLSectionGroupVC alloc]initWithNibName:nil bundle:nil];
    selectGroupVC.friendJID=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.jidStr,XMPP_HOST_DOMAIN]];
    selectGroupVC.fromType=1;
    [self.navigationController pushViewController:selectGroupVC animated:YES];
   }

/**
 *  功能:头部
 */

-(void)addInfoView{
    [headerView loadViewWithName:[self.userDic objectForKey:@"userName"] Subject:nil];
    NSString * imgStr=[self.userDic objectForKey:@"photo"];
    if (imgStr.length>0) {
        NSData *base64Data = [imgStr dataUsingEncoding:NSASCIIStringEncoding];
        NSData *decodedData = [base64Data xmpp_base64Decoded];
        UIImage *img = [UIImage imageWithData:decodedData];
        [headerView.picImgView setImage:img];
    } else {
        [headerView.picImgView setImage:[UIImage imageNamed:@"defaultPerson"]];
    }
    
    [self.tableView reloadData];

}

#pragma mark -UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
	}
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text=@"ID";
            cell.detailTextLabel.text=@"";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
            break;
        case 1:{
            cell.textLabel.text=@"个性签名";
            cell.detailTextLabel.text=@"";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
            break;
        default:
            break;
    }
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
