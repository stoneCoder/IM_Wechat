//
//  RLCreateRoomVC.m
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLCreateRoomVC.h"
#import "XMPPRoom.h"
#import "XMPPManager.h"
#import "IMAlert.h"
#import "RLMyInfo.h"
#import "RLRoomLogic.h"
#import "RLGroupVO.h"
#import "RLRoom.h"
#import "RLCreateRoomInfoVC.h"

@interface RLCreateRoomVC ()
{
    XMPPStream *xmppStream;
    XMPPRoom *xmppRoom;
    NSString *roomName;
}
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@end

@implementation RLCreateRoomVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.roomNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeNaviLeftButtonVisible:YES];
    self.roomNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.logic = [[RLGroupLogic alloc] init];
    [self setTitleText:@"创建群"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClick:(id)sender {
    NSString *roomNaturalName = [self.roomNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (roomNaturalName.length == 0) {
        [self showStringHUD:@"请输入群名称" second:1.5];
        return;
    }
    [self showHUD:@"组群创建中"];
    
    __block RLRoom *room = [RLRoom MR_createEntity];
    [room createRoom:roomNaturalName withCompletion:^(BOOL finished){
        if (finished) {
            RLCreateRoomInfoVC *createRoomInfoVC = [[RLCreateRoomInfoVC alloc] init];
            createRoomInfoVC.room = room;
            [self.navigationController pushViewController:createRoomInfoVC animated:YES];
        }
        [self hideAllHUD];
    }];
    /*
    [RLRoomLogic createRoom:self.roomNameTextField.text withUserJID:[XMPPManager sharedInstance].xmppStream.myJID.bare withDescription:@"description" withSubject:@"subject" withNaturalName:@"" withView:self.view success:^(id json){
        RLGroupVO * group = [[RLGroupVO alloc] init];
        NSDictionary *dic = [json objectForKey:@"mucroomVo"];
        [group setValuesForKeysWithDictionary:dic];
        
        NSString * roomJidStr=[NSString stringWithFormat:@"%@@conference.%@",group.roomName,XMPP_HOST_DOMAIN];
        XMPPJID * roomJID = [XMPPJID jidWithString:roomJidStr];

        xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
        [xmppRoom joinRoomUsingNickname:[RLMyInfo sharedRLMyInfo].name history:nil];

        RLGroupSetInfoVC * infoVC=[[RLGroupSetInfoVC alloc]initWithNibName:nil bundle:nil];
        infoVC.xmppRoom = xmppRoom;
        infoVC.isOwner = YES;
        infoVC.roomJID= xmppRoom.roomJID;
        infoVC.roomSubject= xmppRoom.roomSubject;
        infoVC.createFlag = 0;
        infoVC.group = group;
        [self.navigationController pushViewController:infoVC animated:YES];
    } failure:^(id json){
        
    }];
     */
    /*
    NSString * roomJidStr=[NSString stringWithFormat:@"%@@conference.%@",self.roomNameTextField.text,XMPP_HOST_DOMAIN];
    XMPPJID *roomJID = [XMPPJID jidWithString:roomJidStr];
    [self.logic searchGroupInfoByName:self.roomNameTextField.text andUserJID:[[XMPPManager sharedInstance].xmppStream.myJID bare] success:^(id json) {
        [self hideHUD];
        NSDictionary * dic=[(NSDictionary *)json objectForKey:@"mucroomVo"];
        if (dic.count == 0) {
            xmppStream = [XMPPManager sharedInstance].xmppStream;
            xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
            [xmppRoom activate:xmppStream];
            [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
            [xmppRoom joinRoomUsingNickname:[RLMyInfo sharedRLMyInfo].name history:nil];
        }else
        {
            [[IMAlert alloc] alert:@"该群已存在" delegate:self];
            return;
        }
    } failure:^(NSError *err) {
        [self failureHideHUD];
    }];
    */
}

@end
