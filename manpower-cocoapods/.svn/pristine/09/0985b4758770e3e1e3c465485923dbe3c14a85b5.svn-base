//
//  RLMessageHomeVC.m
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLMessageHomeVC.h"
#import "XMPPManager.h"
#import "NSData+XMPP.h"
#import "TopTabView.h"
#import "RLMessagesListVC.h"
#import "RLNotificationsListVC.h"
@interface RLMessageHomeVC ()<TopTabViewDelegate>
{
    RLBaseVC * currentVC;
    RLMessagesListVC * messagesListVC;
    RLNotificationsListVC * notificationListVC;
}
@end

@implementation RLMessageHomeVC

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
    NSArray * titleAry=@[@"消息",@"通知"];
    TopTabView * tabView=[[TopTabView alloc]initWithFrame:CGRectMake(0, 0, 108, 30) withTitleArray:titleAry];
    tabView.delegate=self;
    self.navigationItem.titleView = tabView;
    
    messagesListVC=[[RLMessagesListVC alloc]initWithNibName:nil bundle:nil];
    messagesListVC.view.frame=self.view.bounds;
    [self addChildViewController:messagesListVC];
    
    notificationListVC=[[RLNotificationsListVC alloc]initWithNibName:nil bundle:nil];
    notificationListVC.view.frame=self.view.bounds;
    [self addChildViewController:notificationListVC];
    
    [self.view addSubview:messagesListVC.view];
    currentVC=messagesListVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TopTabViewDelegate
/**
 *  功能:视图切换
 */

-(void)tabBarSelected:(int)selectIndex{
    if ((currentVC==messagesListVC && selectIndex==1) || (currentVC==notificationListVC && selectIndex==2)) {
        return;
    }
    switch (selectIndex) {
        case 1:
        {
            [self transitionFromViewController:currentVC toViewController:messagesListVC duration:4.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
               currentVC=messagesListVC;
            }];

        }
            break;
        case 2:
        {
            [self transitionFromViewController:currentVC toViewController:notificationListVC duration:4.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
                currentVC=notificationListVC;
            }];
        
        }
            break;
        default:
            break;
    }
    
    
    
}
@end
