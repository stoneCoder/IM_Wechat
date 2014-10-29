//
//  RLGroupVO.h
//  manpower
//
//  Created by hanjin on 14-6-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVO.h"

@interface RLGroupVO : RLBaseVO
@property (strong,nonatomic) NSString * roomName;//房间唯一名称
@property (strong,nonatomic) NSString * roomDescription;//描述
@property (strong,nonatomic) NSString * roomJid;
@property (strong,nonatomic) NSString * roomID;
@property (strong,nonatomic) NSString * roomNaturalLanguageName;
@property (strong,nonatomic) NSString * roomSubject;
@property (strong,nonatomic) NSString * owner;
@property (strong,nonatomic) NSString * ownerName;
@property (strong,nonatomic) NSString * photo;
@property (nonatomic) NSUInteger sum;
@property (nonatomic) NSUInteger onlineCount;


-(void)save;
-(void)update;
-(void)updateWithView:(UIView*)view
              success:(void(^)(id responseObject))success
              failure:(void(^)(id responseObject))failure;
@end
