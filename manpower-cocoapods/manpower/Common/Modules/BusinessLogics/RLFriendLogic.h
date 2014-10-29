//
//  RLFriendLogic.h
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLBaseLogic.h"

@interface RLFriendLogic : RLBaseLogic
DEFINE_SINGLETON_FOR_HEADER(RLFriendLogic)

/**
 *  功能:查找用户
 *  参数:
 *  返回:
 * http://192.168.102.75:9090/plugins/ofsearchplugin/ofsearchplugin?username=hanmin
 */
-(void)searchFriendInfoByAccount:(NSString *)aAccount
                         success:(void (^)(id json))success
                         failure:(void (^)( NSError *err))failure;

+(void)getFriendWithKeyword:(NSString*)keyword
                     success:(void (^)(id json))success
                     failure:(void (^)(id json))failure;

+(void)getFriendListWithUsername:(NSString*)username
                         success:(void (^)(id json))success
                         failure:(void (^)(id json))failure;
@end
