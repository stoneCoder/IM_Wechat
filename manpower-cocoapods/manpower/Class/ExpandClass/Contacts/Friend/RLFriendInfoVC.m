//
//  RLFriendInfoVC.m
//  manpower
//
//  Created by Brian on 14-6-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFriendInfoVC.h"
#import "XMPPManager.h"
#import "IMLabel.h"
#import "XMPPvCardTemp.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RLMyInfoHeaderView.h"
#import <objc/runtime.h>
#import "IMMessageHelper.h"
#import "RLFriend.h"
#import "RLPersonLogic.h"
#import "UIColor+ColorComponent.h"
#import "UIImage+MostColor.h"


@interface RLFriendInfoVC(){
    UILabel *signatureLabel;
    NSIndexPath *selectedIndexPath;
    __block RLFriend *friend;
    BOOL isBinded;
    BOOL isFriend;
    NSArray *dataSource;
}
@property(strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) IBOutlet RLMyInfoHeaderView *headerView;
@end

@implementation RLFriendInfoVC
@synthesize friend;

static NSString *friendInfoCell = @"friendInfoCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleText:@"个人信息"];
        [self makeNaviLeftButtonVisible:YES];
        self.hidesBottomBarWhenPushed = YES;
        _xmpp = [XMPPManager sharedInstance];
        [_xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//        _needGroupCell = YES;
        isBinded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSString *username = self.friendJID.user;
    friend = [RLFriend MR_findFirstByAttribute:@"username" withValue:username];
    if (!friend) {
        friend = [RLFriend MR_createEntity];
//        friend.remark = RAC_EMPTY_STRING;
//        friend.signature = RAC_EMPTY_STRING;
        friend.username = username;
    }
    if (!isBinded) {
        [self bindValuesToView];
    }
    [RLPersonLogic getPersonInfoWithUsername:username withView:nil
                                     success:^(id responseObject){
//                                         friend = [RLFriend MR_findFirstByAttribute:@"username" withValue:username];
//                                         if (!friend) {
//                                             friend = [RLFriend MR_createEntity];
//                                         }
//                                         if (!isBinded) {
//                                             [self bindValuesToView];
//                                         }
                                         if ([friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]]) {
//                                             if (friend.remark == nil) {
//                                                 friend.remark = RAC_EMPTY_STRING;
//                                             }
//                                             if (friend.signature == nil) {
//                                                 friend.signature = RAC_EMPTY_STRING;
//                                             }
                                             [friend.managedObjectContext MR_saveOnlySelfAndWait];
                                             [self.tableView reloadData];
                                         }
                                     } failure:NULL];
    
    // 检查是否为好友，如果从群里点头像过来的，则不一定是好友。
    isFriend = [self checkFriends:self.friendJID.bare];
    /*
    if (isFriend) {
        dataSource = @[@{@"key":@"备注:",
                         @"value":friend.remark,
                         @"index":@0},
                       
                       @{@"key":@"ID:",
                         @"value":friend.username,
                         @"index":@1},
                       
                       @{@"key":@"个性签名:",
                         @"value":friend.signature,
                         @"index":@2}];
    }*/
    
    [super viewDidLoad];
    [self setupHeaderView];
    [self changeButtonFunction];
    [self getViewData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initailize views
-(void)setupHeaderView{
    NSString *title = friend.name ? friend.name : @"";
    NSString *subtitle = friend ? [NSString stringWithFormat:@"%@ %@岁",[friend genderText], friend.age] : @"";
    self.headerView = [RLMyInfoHeaderView headerViewWithTitle:title withSubtitle:subtitle];
    
    // 设置tableview大小
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.tableView.tableHeaderView = self.headerView;
    
    if (friend) {
        [self bindValuesToView];
    }
}

-(void)bindValuesToView{
    isBinded = YES;
    
    // 自己的昵称
    @weakify(self);
    /*
    [RACObserve(friend, age) subscribeNext:^(NSNumber *age){
        @strongify(self);
        if (age.intValue > 0 ) {
            self.headerView.subtitleLabel.text = [self.headerView.titleTextField.text stringByAppendingFormat:@" %d岁",[age intValue]];
        }
    }];
     */
    

    RAC(self.headerView.subtitleLabel,text) = [RACSignal combineLatest:[NSArray arrayWithObjects:RACObserve(friend, age), RACObserve(friend, sex), nil] reduce:^(NSNumber* age, NSNumber* sex){
        NSString *gender;
        switch ([sex integerValue]) {
            case 0:
                gender = @"男";
                break;
                
            default:
                gender = @"女";
                break;
        }
        NSString *result = gender;
        if (age.integerValue) {
            result = [NSString stringWithFormat:@"%@ %@岁",gender,age];
        }
        return result;
    }];
    
    
    [RACObserve(friend, name) subscribeNext:^(NSString *nameStr){
        @strongify(self);
        self.headerView.titleTextField.text = nameStr;
    }];
    
    [RACObserve(friend, photo) subscribeNext:^(NSString *urlStr){
        @strongify(self);
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.headerView.photoIV sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
    }];
    
    [RACObserve(friend, background) subscribeNext:^(NSString *urlStr){
        @strongify(self);
        if (urlStr.length) {
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.headerView.backgroundIV sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_BACKGROUND];
        }
    }];
    
    
    // 更新文字颜色
    [RACObserve(self.headerView.backgroundIV, image) subscribeNext:^(UIImage *image){
        @strongify(self);
        UIImage *rightBottomImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(100, 280, 200, 36))];
        UIColor *color = [rightBottomImage mostColor];
        BOOL isLightColor = [color isLightColor];
        UIColor *textColor = isLightColor ? [UIColor blackColor] : [UIColor whiteColor];
        self.headerView.titleTextField.textColor = textColor;
    }];
}

#pragma mark - tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return isFriend ? 2 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == 0) {
        row = isFriend ? 3 : 2; // 不是好友，则不显示备注栏
    }else{
        row = 1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    if ((isFriend && indexPath.section == 0 && indexPath.row == 2) || (!isFriend && indexPath.section == 0 && indexPath.row == 1)){
        signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
        signatureLabel.font = [UIFont systemFontOfSize:14];
        signatureLabel.numberOfLines = 0;
        signatureLabel.text = friend.signature;
        [signatureLabel sizeToFit];
        height = signatureLabel.frame.size.height+20;
        height = height < 50 ? 50 :height;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    footerView.backgroundColor = UIColorFromRGB(0xeeeeee);
    UIImageView *topSeperatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    topSeperatorIV.backgroundColor = UIColorFromRGB(0xcccccc);
    
    UIImageView *bottomSeperatorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, 0.5)];
    bottomSeperatorIV.backgroundColor = UIColorFromRGB(0xcccccc);

    return footerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendInfoCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:friendInfoCell];
//        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        selectedBackgroundView.backgroundColor = UIColorFromRGB(0xeeeeee);
//        cell.selectedBackgroundView = selectedBackgroundView;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    __block UITableViewCell *blockCell = cell;
    
    if (indexPath.section == 0) {
//        [self configureCell:blockCell withIndexPath:indexPath];
        if (isFriend) {
            switch (indexPath.row) {
                case 0:{
                    blockCell.textLabel.text = @"备注";
                    blockCell.detailTextLabel.text = @"";
//                    RAC(friend, remark) = blockCell.detailTextLabel.;
                    [[RACObserve(friend, remark) distinctUntilChanged] subscribeNext:^(NSString *remark){
                        blockCell.detailTextLabel.text = remark;
                        blockCell.detailTextLabel.alpha = 1;
                        [blockCell.detailTextLabel sizeToFit];
                        [blockCell addSubview:blockCell.detailTextLabel];
                    }];
                    break;
                }
                case 1:
                {
                    blockCell.textLabel.text = @"ID";
                    blockCell.detailTextLabel.text = @"";
                    
                    [RACObserve(friend, username) subscribeNext:^(NSString *username){
                        blockCell.detailTextLabel.text = username;
                    }];
                    break;
                }
                    //        case 3:
                    //            blockCell.textLabel.text = @"所在地";
                    //            blockCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //            break;
                case 2:{
                    blockCell.textLabel.text = @"个性签名";
                    blockCell.detailTextLabel.text = @"";
                    blockCell.detailTextLabel.numberOfLines = 0;
                    blockCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                    [RACObserve(friend, signature) subscribeNext:^(NSString *signature){
                        blockCell.detailTextLabel.text = [signature isEqualToString:RAC_EMPTY_STRING] ? @"" : signature;
                        [blockCell.detailTextLabel sizeToFit];
                    }];
                    
                    
                    break;
                }
                default:
                    break;
            }

        }else{
            switch (indexPath.row) {
                case 0:
                {
                    blockCell.textLabel.text = @"ID";
                    blockCell.detailTextLabel.text = @"";
                    
                    [RACObserve(friend, username) subscribeNext:^(NSString *username){
                        blockCell.detailTextLabel.text = [username isEqualToString:RAC_EMPTY_STRING] ? @"" : username;
                    }];
                    break;
                }
                case 1:{
                    blockCell.textLabel.text = @"个性签名";
                    blockCell.detailTextLabel.text = @"";
                    blockCell.detailTextLabel.numberOfLines = 0;
                    blockCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                    [RACObserve(friend, signature) subscribeNext:^(NSString *signature){
                        blockCell.detailTextLabel.text = [signature isEqualToString:RAC_EMPTY_STRING] ? @"" : signature;
                        [blockCell.detailTextLabel sizeToFit];
                    }];
                    
                    
                    break;
                }
                default:
                    break;
            }

        }
    }else{
        switch (indexPath.row) {
            case 0:
                blockCell.textLabel.text = @"分组";
                blockCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                blockCell.detailTextLabel.text = self.sectionName;
                break;
                
            default:
                break;
        }

    }

    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    __block UITableView *weakTableView = tableView;
    if (isFriend) {
        selectedIndexPath = indexPath;
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{    // 备注
                    [self updateNickNameClick];
                    break;
                }
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:{    // 分组
                    [self changeGroup];
                    break;
                }
                default:
                    break;
            }
            // 修改密码
            //        RLResetPasswordVC *resetPasswordVC = [[RLResetPasswordVC alloc] init];
            //        [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }
    }

    
}




-(void)changeButtonFunction
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    if ([self checkFriends:[self.friendJID bare]]) {
        self.sendButton = [[UIButton alloc] init];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"btn-seed-message"] forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"btn-seed-message-sel"] forState:UIControlStateHighlighted];
        self.sendButton.frame = CGRectMake(9, 6, 147, 44);
        [self.sendButton addTarget:self action:@selector(sendMessageToRoom:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.sendButton];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn-move-friend"] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn-move-friend-sel"] forState:UIControlStateHighlighted];
        self.deleteButton.frame = CGRectMake(164, 6, 147, 44);
        [self.deleteButton addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.deleteButton];
    }else
    {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn-add-friend"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"btn-add-friend-sel"] forState:UIControlStateHighlighted];
        self.addButton.frame = CGRectMake(9, 6, 147, 44);
        [self.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.addButton];

    }
    self.tableView.tableFooterView = footerView;
    
}

-(void)addFriend:(UIButton *)sender
{
//    [self.xmpp AddFriend:self.friendJID.user];
//    IMAlert *alert = [[IMAlert alloc] init];
//    [alert alert:@"申请已发送" delegate:self];
    
    RLSectionGroupVC * selectGroupVC=[[RLSectionGroupVC alloc]initWithNibName:nil bundle:nil];
    selectGroupVC.friendJID = self.friendJID;
    selectGroupVC.fromType=1;
    [self.navigationController pushViewController:selectGroupVC animated:YES];
}

-(BOOL)checkFriends:(NSString *)strJID;
{
    XMPPJID *jid = [XMPPJID jidWithString:strJID];
    return [self.xmpp.xmppRoster.xmppRosterStorage userExistsWithJID:jid xmppStream:self.xmpp.xmppStream];
}

-(void)getViewData
{
    /*获取个人信息*/
    self.friendInfo = [self.xmpp.xmppRosterStorage userForJID:self.friendJID
                                                   xmppStream:self.xmpp.xmppStream
                                         managedObjectContext:[self.xmpp managedObjectContext_roster]];
    if ([[self.friendInfo.groups allObjects] count] != 0) {
        XMPPGroupCoreDataStorageObject * group=[self.friendInfo.groups.allObjects objectAtIndex:0];
        self.sectionName = group.name;
    }else
    {
        if ([self checkFriends:[self.friendJID bare]]) {
            self.sectionName = kDefaultGroupName;
        }
    }
//    self.headerView.subjectLab.text = self.friendInfo.displayName;
//    self.nickNameCell.infoLabel.text = self.friendInfo.nickname;
//    self.groupCell.infoLabel.text = self.sectionName;
//    self.remarkCell.infoLabel.text = self.friendInfo.displayName;
}


-(void)changeGroup
{
    RLSectionGroupVC *rlSectionGroupVC = [[RLSectionGroupVC alloc] init];
    rlSectionGroupVC.friendJID = self.friendJID;
    rlSectionGroupVC.sectionName = self.sectionName;
    [self.navigationController pushViewController:rlSectionGroupVC animated:YES];
}

- (void)updateNickNameClick{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.delegate=self;
    alert.tag=-1;
    [alert show];
}

#pragma mark - Configure UITableViewCell
-(void)configureCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    __weak NSDictionary *dataDic = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dataDic objectForKey:@"key"];
    cell.detailTextLabel.text = [dataDic objectForKey:@"value"];
//    [RACObserve(friend, remark) subscribeNext:^(NSString *remark){
//        cell.detailTextLabel.text = remark;
//    }];
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == -1) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        self.nickName = tf.text;
        if (buttonIndex == 1) {
            [self.xmpp changeNickNameByJID:self.friendJID useNickName:self.nickName andGroups:self.sectionName];
//            self.nickNameCell.infoLabel.text = self.nickName;
//            self.headerView.subjectLab.text = self.nickName;
//            self.remarkCell.infoLabel.text = self.nickName;
            
            // 更新RLFriend
            friend.remark = self.nickName;
            [friend.managedObjectContext MR_saveOnlySelfAndWait];
            
            // 更新最近联系人的昵称
            if (tf.text.length == 0) {
                self.nickName = friend.name;
            }
            NSDictionary *dic = @{@"nickname": self.nickName,
                                  @"jid": [self.friendJID bare]};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOFITICATION_CHANGE_FRIEND_NICKNAME object:nil userInfo:dic];
//            [self.tableView reloadData];
            return;
        }
        return;
    }

    if (buttonIndex != 0) {
        [self.xmpp removeFriend:self.friendInfo.jid.user];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)sendMessageToRoom:(UIButton *)sender
{
    if (self.backFlag == -1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        RLSendMessageVC *sendMessageVC = [[RLSendMessageVC alloc] init];
        sendMessageVC.friendJID = self.friendInfo.jid;
        sendMessageVC.type = @"chat";
        sendMessageVC.isInfo = -1;
        [self.navigationController pushViewController:sendMessageVC animated:YES];
    }
    
}

-(void)deleteFriend:(UIButton *)sender
{
    IMAlert *alert = [[IMAlert alloc] init];
    [alert alertCancelOK:@"确定删除？" delegate:self];
}
@end