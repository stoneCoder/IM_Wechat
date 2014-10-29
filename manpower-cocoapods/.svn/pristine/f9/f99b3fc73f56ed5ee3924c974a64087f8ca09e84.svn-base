//
//  RLAddFriendListTVC.m
//  manpower
//
//  Created by WangShunzhou on 14-9-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLAddFriendListVC.h"
#import "AddFriendListCell.h"
#import "RLSearchFriendResault.h"
#import "RLFriendInfoVC.h"
#import "RLPersonLogic.h"
#import "RLFriend.h"

@interface RLAddFriendListVC ()
@property (nonatomic,strong) NSString *hintString;
@property (nonatomic,assign) IBOutlet UILabel *hintLabel;
@property (nonatomic,strong) AddFriendListCell *friendListCell;
@end
static NSString *cellIdentifier = @"AddFriendListCellIdentifier";

@implementation RLAddFriendListVC

- (id)init
{
    self = [super init];
    if (self) {
        _hintString = @"共找到0个用户";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hintString = [NSString stringWithFormat:@"共找到%d个用户",[self.dataArr count]];
    self.hintLabel.text = _hintString;
    [self makeNaviLeftButtonVisible:YES];
    UINib *nib = [UINib nibWithNibName:@"AddFriendListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    _friendListCell = [[[NSBundle mainBundle] loadNibNamed:@"AddFriendListCell" owner:self options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _friendListCell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    [cell configureCell:dic];
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block RLFriendInfoVC *friendInfoVC = [[RLFriendInfoVC alloc] init];
    __block RLFriend *friend;

    NSString *username = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"userName"];
    friendInfoVC.friendJID = [XMPPJID jidWithUser:username domain:XMPP_HOST_DOMAIN resource:XMPP_HOST_RESOURCE];
    [self showHUD];
    @weakify(self);
    [RLPersonLogic getPersonInfoWithUsername:username withView:self.tableView
                                     success:^(id responseObject){
                                         @strongify(self);
                                         friend = [RLFriend MR_findFirstByAttribute:@"username" withValue:username];
                                         if (!friend) {
                                             friend = [RLFriend MR_createEntity];
                                         }
                                         if ([friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]]) {
                                             [friend.managedObjectContext MR_saveOnlySelfAndWait];
                                             friendInfoVC.friend = friend;
                                             [self.navigationController pushViewController:friendInfoVC animated:YES];
                                             [self hideHUD];
                                         }
                                     } failure:NULL];
    
//    RLSearchFriendResault *resultVC = [[RLSearchFriendResault alloc] init];
//    resultVC.jidStr = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"userName"];
//    [self.navigationController pushViewController:resultVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
