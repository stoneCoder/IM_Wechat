//
//  RLContactsHomeVC.m
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLContactsHomeVC.h"
#import "RLFrendListVC.h"
#import "RLAddFriendVC.h"
@interface RLContactsHomeVC ()
{
    RLFrendListVC * frendListVC;
}
@end

@implementation RLContactsHomeVC

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
    [self setTitleText:@"联系人"];
    
    
    UIButton * rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 27, 24)];
    [rightBtn setImage:[UIImage imageNamed:@"add_contact"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"add_contact_sel"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem;
    
    
    frendListVC=[[RLFrendListVC alloc]initWithNibName:nil bundle:nil];
    CGRect frendFrame=self.view.bounds;
    frendListVC.view.frame=frendFrame;
    [self addChildViewController:frendListVC];
    frendListVC.view.backgroundColor=[UIColor redColor];
    [self.view addSubview:frendListVC.view];
}


/**
 *  功能:添加
 */

-(void)rightBtnClick{
    RLAddFriendVC * addFriendVC=[[RLAddFriendVC alloc]initWithNibName:nil bundle:nil];
    addFriendVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
