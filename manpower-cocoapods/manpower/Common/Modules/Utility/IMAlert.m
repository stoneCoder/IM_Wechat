//
//  IMAlert.m
//  travel
//
//  Created by hanjin on 14-5-14.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMAlert.h"
@interface IMAlert()
@property(nonatomic, assign) BOOL alertShowing;//是否已弹出alert view
@end
@implementation IMAlert
DEFINE_SINGLETON_FOR_CLASS(IMAlert)
- (void)alert:(NSString *)aMessage
{
    if (!self.alertShowing) {
        self.alertShowing = YES;
        [self alert:aMessage delegate:self];
    }
}

- (void)alert:(NSString *)aMessage andInterfaceName:(NSString *)name
{
    if (!self.alertShowing) {
        self.alertShowing = YES;
#ifdef DEBUG
        NSString *msg = [NSString stringWithFormat:@"(接口:%@)%@",name,aMessage];
        [self alert:msg delegate:self];
#else
        [self alert:aMessage delegate:self];
#endif
    }
}

- (void)alertNetError
{
    [self alert:@"当前网络不可用，请检查你的网络设置..."];
}

- (void)alertNetErrorWithInterfaceName:(NSString *)name
{
#ifdef DEBUG
    NSString *msg = [NSString stringWithFormat:@"(接口:[%@])当前网络不可用，请检查你的网络设置...",name];
    [self alert:msg];
#else
    [self alert:@"当前网络不可用，请检查你的网络设置..."];
#endif
}

- (void)alertServerError
{
    [self alert:@"系统繁忙，请稍后重试..."];
}

- (void)alertServerErrorWithInterfaceName:(NSString *)name
{
#ifdef DEBUG
    NSString *msg = [NSString stringWithFormat:@"(接口:[%@])系统繁忙，请稍后重试...",name];
    [self alert:msg];
#else
    [self alert:@"系统繁忙，请稍后重试..."];
#endif
}

//返回json格式数据时  服务器返回错误提示
-(void)alertWithServerReturnMessage:(NSString *)aMessage
{
    [self alert:aMessage];
}

- (void)alert:(NSString *)aMessage delegate:(id/*<UIAlertViewDelegate>*/)aDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:aMessage
                                                   delegate:aDelegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertCancelOK:(NSString *)aMessage delegate:(id)aDelegate
{
    [self alertCancelOK:aMessage title:nil delegate:aDelegate];
}

- (void)alertCancelOK:(NSString *)aMessage  title:(NSString *)aTitle  delegate:(id)aDelegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                    message:aMessage
                                                   delegate:aDelegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.alertShowing = NO;
}

@end
