//
//  RLMemberVO.h
//  manpower
//
//  Created by hanjin on 14-6-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVO.h"

@interface RLMemberVO : RLBaseVO
@property (strong,nonatomic) NSString * jid;
@property (strong,nonatomic) NSString * affiliation;//10-群主,20-管理员
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSString * online;
@property (strong,nonatomic) NSString * photo;
@end
