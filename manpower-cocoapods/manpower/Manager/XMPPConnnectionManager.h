//
//  XMPPLoginManager.h
//  manpower
//
//  Created by WangShunzhou on 14-8-13.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPConnnectionManager : NSObject
DEFINE_SINGLETON_FOR_HEADER(XMPPConnnectionManager)

@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, assign) BOOL loginFlag;    //是否需要自动登陆


-(void)login;
-(void)logOut;
@end
