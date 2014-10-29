//
//  IMAlert.h
//  travel
//
//  Created by hanjin on 14-5-14.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMAlert : NSObject
DEFINE_SINGLETON_FOR_HEADER(IMAlert)
- (void)alert:(NSString *)aMessage;
- (void)alert:(NSString *)aMessage andInterfaceName:(NSString *)name;
- (void)alertNetError;
- (void)alertNetErrorWithInterfaceName:(NSString *)name;
- (void)alertServerError;
- (void)alertServerErrorWithInterfaceName:(NSString *)name;
//返回json格式数据时  服务器返回错误提示
-(void)alertWithServerReturnMessage:(NSString *)aMessage;
- (void)alert:(NSString *)aMessage delegate:(id)aDelegate;
- (void)alertCancelOK:(NSString *)aMessage delegate:(id)aDelegate;
- (void)alertCancelOK:(NSString *)aMessage  title:(NSString *)aTitle  delegate:(id)aDelegate;


@end
