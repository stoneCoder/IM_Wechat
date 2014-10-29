//
//  RLResetPasswordVC.m
//  manpower
//
//  Created by WangShunzhou on 14-9-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLResetPasswordVC.h"
#import "RLMyInfo.h"

@interface RLResetPasswordVC ()
@property(nonatomic,assign) IBOutlet UITextField *oldPasswordTF;
@property(nonatomic,assign) IBOutlet UITextField *passwordTF;
@property(nonatomic,assign) IBOutlet UITextField *confirmPasswordTF;
@end

@implementation RLResetPasswordVC

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
    __block UIButton *rightButton = \
    [self setRightBarButtonWithTitle:@"完成" withTarget:self withSelector:@selector(doneButtonClicked:)];
    [self setReturnBtnTitle:@"返回" BadgeNumber:0];
    
    RAC(rightButton, enabled) = [RACSignal combineLatest:@[self.passwordTF.rac_textSignal, self.confirmPasswordTF.rac_textSignal] reduce:^(NSString *password, NSString *confirmPassword){
        return @([password isEqualToString:confirmPassword] && password.length >= 6);
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneButtonClicked:(id)sender{
    __block RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
    @weakify(self);
    [myInfo updatePassword:self.passwordTF.text withOldPassword:self.oldPasswordTF.text withView:self.view success:^(id json){
        @strongify(self);
        myInfo.password = self.passwordTF.text;
        [myInfo saveUserData];
        [self showStringHUD:@"修改成功！" second:1.5];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        });

    }];
}

@end
