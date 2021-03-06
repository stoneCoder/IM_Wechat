//
//  RLAddFriendVC.m
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLAddFriendVC.h"
#import "XMPPManager.h"
#import "RLSearchFriendResault.h"
#import "IMAlert.h"
#import "RLCreateRoomVC.h"
#import "RLGroupSearchVC.h"
#import "RLFriendInfoVC.h"
#import "RLFriendLogic.h"
#import "RLFriendScanVC.h"
#import "RLAddFriendListVC.h"
#import "UIView+Border.h"
#import "RLInviteFriendVC.h"

@interface RLAddFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *createRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendButton;
@property (strong,nonatomic)  RLFriendLogic * logic;
@property (nonatomic,strong) NSDictionary * userDic;

@end

@implementation RLAddFriendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.logic=[RLFriendLogic sharedRLFriendLogic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"添加"];
    
    /**
     *  Setup UI begins
     */
    self.keywordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.navigationController.navigationBar.translucent = NO;
    [self makeNaviLeftButtonVisible:YES];
    
    self.keywordTextField.layer.borderWidth = 1;
    self.keywordTextField.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.keywordTextField.layer.cornerRadius = 5;
    self.keywordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.keywordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.createRoomButton addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:0.5f];
    [self.searchRoomButton addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:0.5f];
    [self.inviteFriendButton addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:0.5f];
    /**
     *  Setup UI ends
     */

}
- (IBAction)findFriend:(id)sender {
    if (self.keywordTextField.text && self.keywordTextField.text.length>0) {
        
        XMPPRoster * xmpproster=[XMPPManager sharedInstance].xmppRoster;
        XMPPJID * jid=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.keywordTextField.text,XMPP_HOST_DOMAIN]];
        if ([xmpproster.xmppRosterStorage userExistsWithJID:jid xmppStream:[XMPPManager sharedInstance].xmppStream]) {//是否在好友花名册里面（申请过的好友是挂起的，状态是to还是from？，但也在名册里面）
            [[IMAlert alloc] alert:@"已经是您的好友或者您已经申请过了" delegate:self];
        }else
        if([self.keywordTextField.text   isEqualToString:[XMPPManager sharedInstance].xmppStream.myJID.user]){
            [[IMAlert alloc] alert:@"您不能加您自己为好友!" delegate:self];
        }
        else {//调接口取数据
            [self getListDataWithPage];
        }
    }else{
        [[IMAlert alloc] alertCancelOK:@"请输入名称/手机号" delegate:self];
    }
   
}
-(void)getListDataWithPage{
    [self showHUD];
//    [self.logic searchFriendInfoByAccount:self.keywordTextField.text success:^(id json) {
//        [self hideHUD];
//        self.userDic=(NSDictionary *)json;
//        NSString * showMsg=[self.userDic objectForKey:@"showMsg"];
//        if ([showMsg isEqualToString:@"true"]) {
//            RLSearchFriendResault * resaultVC=[[RLSearchFriendResault alloc]initWithNibName:nil bundle:nil];
//            resaultVC.jidStr=self.keywordTextField.text;
//            resaultVC.userDic=self.userDic;
//            [self.navigationController pushViewController:resaultVC animated:YES];
//        } else {
//            [[IMAlert alloc] alert:@"对不起！无此帐号信息!" delegate:self];
//            
//        }
//        
//    } failure:^(NSError *err) {
//        [self failureHideHUD];
//    }];
    @weakify(self)
    [RLFriendLogic getFriendWithKeyword:self.keywordTextField.text success:^(id json){
        @strongify(self)
        NSArray *friendArray = [json objectForKey:@"users"];
        RLAddFriendListVC *addFriendListTVC = [[RLAddFriendListVC alloc] init];
        addFriendListTVC.dataArr = friendArray;
        
        [self hideAllHUD];
        [self.navigationController pushViewController:addFriendListTVC animated:YES];
    } failure:^(id json){
        [self hideAllHUD];
    }];
    
//    [RLFriendLogic getFriendListWithUsername:@"13339997910" success:^(id json){
//        NSLog(@"%@",json);
//    } failure:NULL];
}
#pragma mark - IBAction
//创建群
- (IBAction)createRoom:(id)sender {
    RLCreateRoomVC * createRoomVC=[[RLCreateRoomVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:createRoomVC animated:YES];
}
//查找群 
- (IBAction)searchRoom:(id)sender {
    RLGroupSearchVC * searchGroupVC=[[RLGroupSearchVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:searchGroupVC animated:YES];
}

//查找群
- (IBAction)inviteFriend:(id)sender {
    RLInviteFriendVC * inviteFriendVC=[[RLInviteFriendVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:inviteFriendVC animated:YES];
}

- (IBAction)scanAction:(id)sender {
    RLFriendScanVC * scanVC=[[RLFriendScanVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
