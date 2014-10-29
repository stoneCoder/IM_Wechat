//
//  RLPersonInfoVC.m
//  manpower
//
//  Created by WangShunzhou on 14-9-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLPersonInfoVC.h"
#import "RLMyInfoHeaderView.h"
#import "XMPPManager.h"

@interface RLPersonInfoVC (){
    XMPPManager *xmpp;
}

@end

@implementation RLPersonInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleText:@"个人信息"];
        [self makeNaviLeftButtonVisible:YES];
        xmpp = [XMPPManager sharedInstance];
        [xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
