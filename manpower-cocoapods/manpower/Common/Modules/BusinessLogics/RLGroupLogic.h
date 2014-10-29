//
//  RLGroupLogic.h
//  manpower
//
//  Created by hanjin on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLGroupLogic : NSObject
DEFINE_SINGLETON_FOR_HEADER(RLGroupLogic)
/**
 *  功能:查找群组
 *  参数:roomName=2222
 *  返回:
 * http://192.168.102.143:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=getRoomInfo&roomName=2222
 */
-(void)searchGroupInfoByName:(NSString *)aName
                  andUserJID:(NSString *)userJID
                     success:(void (^)(id json))success
                     failure:(void (^)( NSError *err))failure;
/**
 *  功能:获取用户所在的群组
 *  参数:userId=hanjin
 *  返回:
 * http://192.168.102.143:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=getRoomInfos&userId=hanjin
 */
-(void)getGroupListByName:(NSString *)aName
                  success:(void (^)(id json))success
                  failure:(void (^)( NSError *err))failure;

/**
 *  功能:获取群组所有成员
 *  参数:roomName=2222
 *  返回:
 * http://192.168.102.143:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=getAllJoinUser&roomName=333
 */
-(void)getMemberListByGroupName:(NSString *)aName
                        success:(void (^)(id json))success
                        failure:(void (^)( NSError *err))failure;

/**
 *  功能:退出群
 *  参数:roomName=2222 JID=hanjin2@hanmin
 *  返回:
 * http://192.168.102.143:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=leaveRoom&roomName=2222&userJID=hanjin2@hanmin
 */
-(void)leaveGroupByUserJID:(NSString *)userJID
               andRoomName:(NSString *)roomName
                   success:(void (^)(id json))success
                   failure:(void (^)( NSError *err))failure;

/**
 *  功能:解散群
 *  参数:roomName=2222 JID=hanjin2@hanmin
 *  返回:
 * http://192.168.102.143:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=destroyRoom&roomName=1111&userJID=123@hanmin
 */
-(void)dismissGroupByUserJID:(NSString *)userJID
                 andRoomName:(NSString *)roomName
                     success:(void (^)(id json))success
                     failure:(void (^)( NSError *err))failure;

/**
 *  功能:加入群
 *  参数:roomName=2222 JID=hanjin2@hanmin
 *  返回:
 * http://192.168.102.75:9090/plugins/ofroomplugin/ofroomplugin?subdomain=conference&type=saveMember&roomName=aaa&userJID=hanmin@hanmin
 */
-(void)joinGroupByUserJID:(NSString *)userJID
                 andRoomName:(NSString *)roomName
                     success:(void (^)(id json))success
                     failure:(void (^)( NSError *err))failure;
@end
