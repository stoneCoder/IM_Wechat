//
//  RLPassWordVC.m
//  manpower
//
//  Created by Brian on 14-6-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLPassWordVC.h"
#import "RLRegisterLogic.h"

@interface RLPassWordVC ()
@property(nonatomic, assign) IBOutlet UILabel *rePasswordHintLabel;
@property(nonatomic, assign) IBOutlet UIView *repasswordErrorView;
@property(nonatomic, assign) IBOutlet UIButton *doneButton;
@end

static NSUInteger kPasswordLengthMin = 6;
static NSUInteger kPasswordLengthMax = 16;

@implementation RLPassWordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.xmpp = [XMPPManager sharedInstance];
        [self.xmpp.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSString *myJID = [self.xmpp getFullJID:@""];
        [self.xmpp.xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
        [self.xmpp connect];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"填写密码"];
    [self makeNaviLeftButtonVisible:YES];
//    UIButton * rightBtn=[[UIButton alloc] init];
//    rightBtn.frame = CGRectMake(0, 0, 54, 28);
//    [rightBtn setImage:[UIImage imageNamed:@"btn_done"] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"btn_done_sel"] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:self action:@selector(regButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * buttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem=buttonItem;
    
    self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.repasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passwordText becomeFirstResponder];
    
    @weakify(self);
    
    // 设置密码框长度
    [[self.passwordText.rac_textSignal filter:^BOOL(NSString *password){
        return ([password length] > kPasswordLengthMax);
    }] subscribeNext:^(NSString *password){
        @strongify(self);
        self.passwordText.text = [password substringToIndex:kPasswordLengthMax];
    }];
    
    // 设置重复密码框长度
    [[self.repasswordText.rac_textSignal filter:^BOOL(NSString *password){
        return ([password length] > kPasswordLengthMax);
    }] subscribeNext:^(NSString *password){
        @strongify(self);
        self.repasswordText.text = [password substringToIndex:kPasswordLengthMax];
    }];

    // 重复密码与密码是否相等
    RACSignal *passwordConfirmSignal = [RACSignal combineLatest:@[self.passwordText.rac_textSignal, self.repasswordText.rac_textSignal] reduce:^(NSString* password, NSString* rePassword){
        if (rePassword.length >= password.length) {
            return @([password isEqualToString:rePassword]);
        }
        return @YES;
    }];
    
    // 验证密码是否合法
    RACSignal *doneButtonEnabledSignal = [RACSignal combineLatest:@[self.passwordText.rac_textSignal, self.repasswordText.rac_textSignal] reduce:^(NSString* password, NSString* rePassword){
        if (password.length < kPasswordLengthMin || password.length > kPasswordLengthMax) {
            return @NO;
        } else if (![password isEqualToString:rePassword]) {
            return @NO;
        }
        return @YES;
    }];
    
    // 按下完成按钮
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button){
        @strongify(self);
        self.doneButton.enabled = NO;
        self.password = self.passwordText.text;
        
        if (_type == 1) {
            @weakify(self);
            [RLRegisterLogic resetPasswordWithPhoneNumber:self.username withCaptcha:self.captcha withPassword:self.password withCurrentView:self.view success:^(id responseObject){
                @strongify(self);
                [self showStringHUD:@"重置成功" second:2];
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } failure:^(id responseObject){
                @strongify(self);
                self.doneButton.enabled = YES;
            }];
        }else{
            @weakify(self);
            [RLRegisterLogic registerWithPhoneNumber:self.username withCaptcha:self.captcha withPassword:self.password withCurrentView:self.view success:^(id responseObject){
                @strongify(self);
                [self showStringHUD:@"注册成功" second:2];
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } failure:^(id responseObject){
                @strongify(self);
                self.doneButton.enabled = YES;
            }];
        }

    }];
    
    RAC(self.repasswordErrorView, hidden) = passwordConfirmSignal;
    RAC(self.doneButton, enabled) = doneButtonEnabledSignal;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)regButtonClicked:(id)sender
{
    NSString *passWordstr = self.passwordText.text;
    NSString *repassWordstr = self.repasswordText.text;
    if ([passWordstr length] <6 || [passWordstr length] >16) {
        [[IMAlert alloc] alert:@"密码长度不正确" delegate:self];
        return;
    }
    if (![passWordstr isEqualToString:repassWordstr]) {
        [[IMAlert alloc] alert:@"两次密码输入不一致" delegate:self];
        return;
    }
    [self registFromService];
}

-(BOOL)registFromService
{
    BOOL registFlag = YES;
    NSString *password = self.passwordText.text;
    NSError *err = nil;
    NSMutableArray *elements = [NSMutableArray array];
//    if (![self.xmpp.xmppStream isConnected]) {
//        XMPPJID *jid = self.xmpp.xmppStream.myJID;
//        if (jid == nil) {
//            jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/%@",self.username,XMPP_HOST_DOMAIN,XMPP_HOST_RESOURCE]];
//            [self.xmpp.xmppStream setMyJID:jid];
//        }
//        [self.xmpp connect];
//    }
    [elements addObject:[NSXMLElement elementWithName:@"username" stringValue:self.username]];
    [elements addObject:[NSXMLElement elementWithName:@"password" stringValue:password]];
    
    [self.xmpp.xmppStream registerWithElements:elements error:&err];
    if (err) {
        registFlag = NO;
        DDLogError(@"%@",err);
    }
    return registFlag;
}

#pragma mark - XMPPManager
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    [self showStringHUD:@"注册成功\n"/**请点击左上角返回登陆**/ second:2];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(registerSuccess:) userInfo:nil repeats:NO];
}

-(void)registerSuccess:(NSTimer*)timer
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    DDLogError(@"%@",error);
    [self showStringHUD:@"注册失败\n" second:2];
}

#pragma mark - IMAlert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


@end
