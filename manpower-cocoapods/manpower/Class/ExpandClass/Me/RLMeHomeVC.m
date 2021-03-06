//
//  RLMeHomeVC.m
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLMeHomeVC.h"
#import "XMPPManager.h"
#import "XMPPvCardTemp.h"
#import "IMLabel.h"
#import "RLMyInfoVC.h"
#import "AppDelegate.h"
#import "FriendDataHelp.h"
#import "XMPPConnnectionManager.h"
#import "RLMyInfo.h"
#import "UIView+Border.h"

enum{
    kPhotoImageView = 100,
    kUsernameLabel = 101,
    kNicknameLabel = 102
};

@interface RLMeHomeVC ()
@property(strong, nonatomic) IBOutlet UITableView *tableView;

@property(assign, nonatomic) IBOutlet UIImageView *photoImageView;
@property(assign, nonatomic) IBOutlet UILabel *nameLabel;
@property(assign, nonatomic) IBOutlet UILabel *usernameLabel;

@property(assign, nonatomic) IBOutlet UIView *personalInfoView;

@property(assign, nonatomic) IBOutlet UIView *contentView;
@property(assign, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation RLMeHomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleText:@"更多"];
        
        xmpp = [XMPPManager sharedInstance];
        [xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);

    // configure scroll view
    CGSize size = self.scrollView.bounds.size;
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.scrollView addSubview:self.contentView];
    size.height++;
    self.scrollView.contentSize = size;
    
    [self.personalInfoView addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:0.5f];
    
//    self.headViewCell = [[RLMeInfoCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 86)];
//    self.headViewCell.topLabel.text = myInfo.name;
//    self.headViewCell.downLabel.text = [NSString stringWithFormat:@"ID:%@",myInfo.username];
//    [self.view addSubview:self.headViewCell];
//    
//    [self.headViewCell addTarget:self action:@selector(changePersonView) forControlEvents:UIControlEventTouchDown];
    
    /*
    self.secondViewCell = [[RLInfoCell alloc] initWithFrame:CGRectMake(0, self.headViewCell.frame.origin.y + self.headViewCell.frame.size.height, self.view.frame.size.width, 86)];
    self.secondViewCell.titleLabel.text = @"个性签名";
    [self.secondViewCell updateBackImge:1];
    [self.view addSubview:self.secondViewCell];
    
    self.thirdViewCell = [[RLInfoCell alloc] initWithFrame:CGRectMake(0, self.secondViewCell.frame.origin.y + self.secondViewCell.frame.size.height, self.view.frame.size.width, 86)];
    self.thirdViewCell.titleLabel.text = @"好友验证";
    [self.thirdViewCell updateBackImge:1];
    [self.view addSubview:self.thirdViewCell];
    
    self.quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.quitButton setBackgroundImage:[UIImage imageNamed:@"btn-quit"] forState:UIControlStateNormal];
    [self.quitButton setBackgroundImage:[UIImage imageNamed:@"btn-quit-sel"] forState:UIControlStateHighlighted];
    self.quitButton.frame = CGRectMake(18, self.thirdViewCell.frame.origin.y + self.secondViewCell.frame.size.height +35, 284, 44);
    [self.quitButton addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.quitButton];
     */
}


-(UIImage *)returnPhote
{
    XMPPvCardTemp *card = [xmpp.xmppvCardTempModule myvCardTemp];
    if (card.jid == nil) {
        card.jid = [xmpp.xmppStream.myJID copy];
    }
    if (card.nickname.length == 0) {
        card.nickname = xmpp.xmppStream.myJID.user;
    }
    UIImage *photoImage;
    if (card.photo != nil) {
        photoImage = [UIImage imageWithData:card.photo];
    }else{
        NSData *photoData = [xmpp.xmppvCardAvatarModule photoDataForJID:card.jid];
        if (photoData) {
            photoImage = [UIImage imageWithData:photoData];
        }else
        {
            photoImage = [UIImage imageNamed:@"defaultPerson"];
        }
    }
    return photoImage;
}

-(IBAction)logoutButtonClicked:(id)sender
{
    
    [[XMPPConnnectionManager sharedXMPPConnnectionManager] logOut];

}

-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*异步加载头像*/
//    dispatch_async(dispatch_get_global_queue(0, 0),^{
//        UIImage *avaterImage = [self returnPhote];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //UI的更新需在主线程中进行
//                [self.headViewCell.headImageView setImage:avaterImage];
//            });
//    });
    
    RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
//    if (myInfo.localPhoto.length) {
//        [self.photoImageView setImage:[UIImage imageWithContentsOfFile:myInfo.localPhoto]];
//    }else{
        NSURL *photoUrl = [NSURL URLWithString:myInfo.photo];
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width * 0.5;
        self.photoImageView.layer.masksToBounds = YES;
        [self.photoImageView sd_setImageWithURL:photoUrl placeholderImage:IMAGE_DEFAULT_PERSON];
//    }
    self.nameLabel.text = myInfo.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"ID: %@", myInfo.username];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)personalInfoViewClicked:(id)sender
{
    RLMyInfoVC *myInfoVC = [[RLMyInfoVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:myInfoVC animated:YES];
}


//#pragma mark - tableview datasource
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 76;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString* meCellIndentifier = @"meCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:meCellIndentifier];
//    XMPPvCardTemp* card = [xmpp.xmppvCardTempModule myvCardTemp];
//    if (card.jid == nil) {
//        card.jid = [xmpp.xmppStream.myJID copy];
//    }
//    if (card.nickname.length == 0) {
//        card.nickname = xmpp.xmppStream.myJID.user;
//    }
//    UIImage *photoImage;
//    if (card.photo != nil) {
//        photoImage = [UIImage imageWithData:card.photo];
//    }else{
//        NSData *photoData = [xmpp.xmppvCardAvatarModule photoDataForJID:card.jid];
//        if (photoData) {
//            photoImage = [UIImage imageWithData:photoData];
//        }else
//        {
//            photoImage = [UIImage imageNamed:@"defaultPerson"];
//        }
//        
//    }
//    
//    UIImageView *photoIV;
//    UILabel *nicknameLabel;
//    UILabel *usernameLabel;
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meCellIndentifier];
//        photoIV = [[UIImageView alloc] initWithFrame:CGRectMake(18, 7, 72, 72)];
//        photoIV.layer.cornerRadius = photoIV.frame.size.width/2;
//        photoIV.layer.masksToBounds = YES;
//        [photoIV setImage:photoImage];
//        photoIV.tag = kPhotoImageView;
//        
//        nicknameLabel = [IMLabel labelWithTitle:[NSString stringWithFormat:@"昵  称：%@",card.nickname]];
//        nicknameLabel.tag = kNicknameLabel;
//        [nicknameLabel setFrame:CGRectMake(60, 5, 200, 20)];
//        [nicknameLabel sizeToFit];
//        
//        usernameLabel = [IMLabel labelWithTitle:[NSString stringWithFormat:@"用户名：%@",card.jid.user]];
//        usernameLabel.tag = kUsernameLabel;
//        [usernameLabel setFrame:CGRectMake(60, 30, 200, 20)];
//        [usernameLabel sizeToFit];
//    }else{
//        photoIV = (UIImageView*)[cell.contentView viewWithTag:kPhotoImageView];
//        [photoIV setImage:photoImage];
//        nicknameLabel = (UILabel*)[cell.contentView viewWithTag:kNicknameLabel];
//        usernameLabel = (UILabel*)[cell.contentView viewWithTag:kUsernameLabel];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.contentView addSubview:photoIV];
//    [cell.contentView addSubview:nicknameLabel];
//    [cell.contentView addSubview:usernameLabel];
//    
//    return cell;
//}
//
//#pragma mark - delegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        RLMyInfoVC *myInfoVC = [[RLMyInfoVC alloc] initWithNibName:nil bundle:nil];
//        [self.navigationController pushViewController:myInfoVC animated:YES];
//    }
//}

@end
