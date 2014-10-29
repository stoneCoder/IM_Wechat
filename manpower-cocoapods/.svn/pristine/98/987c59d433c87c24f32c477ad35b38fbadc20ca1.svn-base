//
//  RLGroupMemberJoinVC.m
//  manpower
//
//  Created by hanjin on 14-6-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupMemberJoinVC.h"
#import "XMPPManager.h"
#import "IMAlert.h"
@interface RLGroupMemberJoinVC ()
{
    XMPPStream * xmppStream;
    NSString * firstName;
    NSString * lastName;
    NSString * nickName;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameLab;
@property (weak, nonatomic) IBOutlet UITextField *lastNameLab;
@property (weak, nonatomic) IBOutlet UITextField *nickLab;
@end

@implementation RLGroupMemberJoinVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.queryFlag = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    xmppStream=[XMPPManager sharedInstance].xmppStream;
//    [XMPPManager sharedInstance].tag=self;
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    [self makeNaviLeftButtonVisible:YES];


}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *type = [iq type];
    NSString *elementID=[iq elementID];
	if ([type isEqualToString:@"result"])
	{
        if ([elementID isEqualToString:@"reg1"]) {
            XMPPJID *myJID = xmppStream.myJID;
            
            NSXMLElement *query =[[iq elementForName:@"query" xmlns:@"jabber:iq:register"] copy] ;
            if ([query elementForName:@"registered"]) {//已经注册
                [[IMAlert alloc] alert:@"您已经在群里面了!" delegate:self];
            } else {//注册
                NSXMLElement * x=[[query elementForName:@"x"] copy];
                [x removeAttributeForName:@"type"];
                [x addAttributeWithName:@"type" stringValue:@"submit"];
                
                NSArray* fields = [x elementsForName:@"field"];
                for (NSXMLElement *field in fields) {
                    NSString *var = [field attributeStringValueForName:@"var"];
                    if ([var isEqualToString:@"muc#register_first"]) {
                        [field removeChildAtIndex:0];
                        [field addChild:[NSXMLElement elementWithName:@"value" stringValue:firstName]];
                    }
                    if ([var isEqualToString:@"muc#register_last"]) {
                        [field removeChildAtIndex:0];
                        [field addChild:[NSXMLElement elementWithName:@"value" stringValue:lastName]];
                    }
                    if ([var isEqualToString:@"muc#register_roomnick"]) {
                        [field removeChildAtIndex:0];
                        [field addChild:[NSXMLElement elementWithName:@"value" stringValue:nickName]];
                    }
                    //                if ([var isEqualToString:@"muc#register_url"]) {
                    //                    [field removeChildAtIndex:0];
                    //                    [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"http://123.com"]];
                    //                }
                    //                if ([var isEqualToString:@"muc#register_email"]) {
                    //                    [field removeChildAtIndex:0];
                    //                    [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"123@123.com"]];
                    //                }
                    //                if ([var isEqualToString:@"muc#register_faqentry"]) {
                    //                    [field removeChildAtIndex:0];
                    //                    [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"123"]];
                    //                }
                    
                }
                
                NSXMLElement *query2 = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:register"];
                [query2 addChild:x];
                NSXMLElement *iq2 = [NSXMLElement elementWithName:@"iq" ];
                [iq2 addAttributeWithName:@"type" stringValue:@"set"];
                [iq2 addAttributeWithName:@"from" stringValue:[myJID full]];
                [iq2 addAttributeWithName:@"to" stringValue:self.roomJidStr];
                [iq2 addAttributeWithName:@"id" stringValue:@"reg2"];
                [iq2 addChild:query2];
                [xmppStream sendElement:iq2];
            }

            
        }else if ([elementID isEqualToString:@"reg2"]){
            [[IMAlert alloc] alert:@"恭喜您，注册成功" delegate:self];
        
        }
        
	}
    return NO;
}
#pragma mark - IBAction
- (IBAction)doneBtnClick:(id)sender {
    if (self.firstNameLab.text.length>0 && self.lastNameLab.text.length>0 && self.nickLab.text.length>0) {
        firstName=self.firstNameLab.text;
        lastName=self.lastNameLab.text;
        nickName=self.nickLab.text;
        //加群
        XMPPJID *myJID = xmppStream.myJID;
        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:register"];
        NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
        [iq addAttributeWithName:@"type" stringValue:@"get"];
        [iq addAttributeWithName:@"from" stringValue:[myJID full]];
        [iq addAttributeWithName:@"to" stringValue:self.roomJidFullStr];
        [iq addAttributeWithName:@"id" stringValue:@"reg1"];
        [iq addChild:query];
        [xmppStream sendElement:iq];
    } else {
        self.queryFlag = NO;
        [[IMAlert alloc] alert:@"请完善信息" delegate:self];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.queryFlag) {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
