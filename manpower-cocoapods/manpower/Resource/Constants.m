//
//  Constants.m
//  manpower
//
//  Created by WangShunzhou on 14-9-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "Constants.h"

//你猜不到我的密码吧？用于加密数据
NSString *const kCryptPwd = @"cn.whzm.IM_WangShunzhou";

// 个人资料保存地址
NSString *const kCryptFilePath = @"Library/Application Support/001.dat";

// 历史用户保存地址
NSString *const kUsernameList = @"Library/001.dat";

// 默认好友分组
NSString *const kDefaultGroupName = @"我的好友";

// 头像图片宽度
CGFloat const kPhotoSizeWidth = 144.0f;

// 按钮默认颜色enable
NSInteger const kEnabledColor = 0xff0000;

// 按钮默认颜色disable
NSInteger const kDisabledColor = 0xEF7F87;