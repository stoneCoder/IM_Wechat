//
//  RLGroupSearchVC.m
//  manpower
//
//  Created by hanjin on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupSearchVC.h"
#import "IMAlert.h"
#import "RLGroupSearchResultVC.h"
@interface RLGroupSearchVC ()
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (strong,nonatomic) XMPPRoomManager *xmppRoomManager;
@property (strong,nonatomic) RLGroupLogic *logic;
@property (strong,nonatomic) NSDictionary * infoDic;
@property (assign,nonatomic) int isOwner;

@end

@implementation RLGroupSearchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       self.keywordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keywordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self makeNaviLeftButtonVisible:YES];
    self.logic=[RLGroupLogic sharedRLGroupLogic];
    [self setTitleText:@"查找群"];
    self.keywordTextField.layer.borderWidth = 1;
    self.keywordTextField.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.keywordTextField.layer.cornerRadius = 5;
    self.keywordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.keywordTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Actions
- (IBAction)searchGroup:(id)sender {
    NSString *keyword = [self.keywordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyword.length>0) {
//        [self getDataWithKeyword:keyword];
        [self getListDataWithPageWithJID:keyword];
    }else{
        [[IMAlert alloc] alertCancelOK:@"请输入ID" delegate:self];
    }
}

-(void)getDataWithKeyword:(NSString*)keyword{
    [self showHUD];
    
}

-(void)getListDataWithPageWithJID:(NSString *)jidStr{
    [self showHUD];
    XMPPJID * jid= [XMPPManager sharedInstance].xmppStream.myJID;
    @weakify(self);
    [self.logic searchGroupInfoByName:jidStr andUserJID:[jid bare] success:^(id json) {
        @strongify(self);
        [self hideHUD];
        NSDictionary * dic=(NSDictionary *)json;
        if ([[dic objectForKey:@"mucroomVo"] count] == 0) {
            [[IMAlert alloc] alert:@"查询无数据" delegate:self];
            return;
        }else
        {
            self.infoDic=[dic objectForKey:@"mucroomVo"];
            if ([[dic objectForKey:@"isExist"] intValue] == 1) {
                [[IMAlert alloc] alert:@"已加入该群" delegate:self];
                return;
                self.isOwner = 2;
            }else
            {
                self.isOwner = 3;
            }
            //查询用户在群中的角色
            [self getRoleFromRoomWithRoomJID:[self.infoDic objectForKey:@"roomJid"]];
        }
        
        RLGroupSetInfoVC * infoVC=[[RLGroupSetInfoVC alloc]initWithNibName:nil bundle:nil];
        infoVC.xmppRoom = self.xmppRoomManager.xmppRoom;
        infoVC.roomJID = self.xmppRoomManager.xmppRoom.roomJID;
        infoVC.roomSubject = [dic objectForKey:@"owner"];
        infoVC.isOwner = self.isOwner;
        infoVC.createFlag = 1;
        [self.navigationController pushViewController:infoVC animated:YES];
    } failure:^(NSError *err) {
        [self failureHideHUD];
    }];
}

-(void)getRoleFromRoomWithRoomJID:(NSString *)jidStr
{
    XMPPJID *roomJID=[XMPPJID jidWithString:jidStr];
    self.xmppRoomManager =  [[XMPPRoomManager alloc] init];
    [self.xmppRoomManager joinRoomWithJid:roomJID andType:self.isOwner];
}

@end
