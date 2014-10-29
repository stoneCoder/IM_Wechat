//
//  RLLoginVC.m
//  manpower
//
//  Created by hanjin on 14-6-3.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLLoginVC.h"
#import "XMPPManager.h"
#import "AppDelegate.h"
#import "RLRegisterVC.h"
#import "AppDelegate.h"
#import "RLSendMessageVC.h"
#import "RLMyInfo.h"
#import "XMPPConnnectionManager.h"
#import "SelectionCell.h"

#import "UserModel.h"

@interface RLLoginVC ()<UITableViewDataSource,UITableViewDelegate,SelectionCellDelegate,UITextFieldDelegate>{
    NSString *account;
    NSString *password;
    XMPPConnnectionManager *xmppConnection;
    BOOL isOpened;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

static NSString *cellIdentifier = @"SelectionCell";
@implementation RLLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        xmpp = [XMPPManager sharedInstance];
        [xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        xmppConnection = [XMPPConnnectionManager sharedXMPPConnnectionManager];
        
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    dataArray = [[UserModel sharedUserModel] getUserList];
    [_tb reloadData];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
        self.edgesForExtendedLayout = UIRectEdgeNone;

    }
    
//    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.navigationController.navigationBarHidden = YES;
    self.accountTextField.text = xmppConnection.username;
    self.passWordTextField.text = xmppConnection.password;
    self.accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (self.accountTextField.text.length && self.passWordTextField.text.length) {
//        [self loginButtonClicked:self.loginButton];
    }
    
    dataArray = [[UserModel sharedUserModel] getUserList];
    
    _tb.dataSource = self;
    _tb.delegate = self;
    
    UINib * cellNib=[UINib nibWithNibName:@"SelectionCell" bundle:nil];
    [_tb registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
//    [_tb.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [_tb.layer setBorderWidth:1.0f];
//    _tb.layer.shadowOffset = CGSizeMake(20,20);
//    _tb.layer.shadowColor = [UIColor blackColor].CGColor;
//    _tb.layer.shadowOpacity = 0.5;
//    _tb.layer.shadowRadius = 2;
//    _tb.layer.masksToBounds = NO;
//    _tb.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tb.bounds].CGPath;
}

#pragma mark - IBActions
- (IBAction)loginButtonClicked:(id)sender {

    account = [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    password = [self.passWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (account.length == 0 || password.length == 0)
    {
        [self showStringHUD:@"用户名 / 密码不能为空" second:1.5];
        return;
    }

    NSString *myJID = [xmpp getFullJID:account];
    [xmpp.xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    
    //连接服务器
    xmppConnection.loginFlag = YES;
    xmppConnection.username = account;
    xmppConnection.password = password;
    [xmppConnection login];
    
    [self.accountTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

-(IBAction)registerButtonClicked:(id)sender{
    RLRegisterVC* regVC = [[RLRegisterVC alloc] initWithNibName:@"RLRegisterVC" bundle:nil];
    UIButton *button = (UIButton*)sender;
    // 点击的是忘记密码
    if (button.tag == 100) {
        regVC.type = 1;
    }

    [self.navigationController pushViewController:regVC animated:YES];
}

-(IBAction)viewTapped:(id)sender{
    [self.accountTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (IBAction)dropAction:(id)sender {
    [self changeDropList];
}

#pragma mark Private
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow:(NSNotification*)notif
{
    float moveY = 60.0f;
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (iOS7) {
        moveY = 90.0f;
    }
    self.view.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, y/2.0 + moveY);
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification*)notif
{
    float moveY = 10.0f;
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (iOS7) {
        moveY = 0.0f;
    }
    self.view.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, y/2.0 - moveY);
    [UIView commitAnimations];
}

-(void)changeDropList
{
    _tb.hidden = NO;
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *closeImage=[UIImage imageNamed:@"drop_down.png"];
            [_dropBtn setImage:closeImage forState:UIControlStateNormal];
            
            CGRect frame = _tb.frame;
            frame.size.height=1;
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=NO;
            _tb.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *openImage=[UIImage imageNamed:@"drop_up.png"];
            [_dropBtn setImage:openImage forState:UIControlStateNormal];
            CGRect frame=_tb.frame;
            frame.size.height=200;
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
}

#pragma mark SelectionCellDelegate
- (IBAction)delAction:(SelectionCell *)cell
{
    NSIndexPath *indexPath = [_tb indexPathForCell:cell];
    NSArray *array = [NSArray arrayWithObjects:indexPath, nil];
    [dataArray removeObjectAtIndex:cell.tag];
    [_tb deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
    [_tb reloadData];
    [[UserModel sharedUserModel] updateUserList:dataArray];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.lb.text = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectStr = [dataArray objectAtIndex:indexPath.row];
    self.accountTextField.text = selectStr;
//    if (!DEBUG) {
//        self.passWordTextField.text = @"";
//    }
    isOpened = YES;
    [self changeDropList];
    
    RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
    if ([self.accountTextField.text isEqualToString:myInfo.username]) {
        self.passWordTextField.text = myInfo.password;
    }else{
        self.passWordTextField.text = @"";
    }
}

#pragma mark - UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    isOpened = YES;
    [self changeDropList];
    return YES;
}

@end
