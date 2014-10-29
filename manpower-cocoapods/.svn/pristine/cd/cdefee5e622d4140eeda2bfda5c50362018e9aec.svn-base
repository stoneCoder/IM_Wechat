//
//  RLPersonLogic.h
//  manpower
//
//  Created by WangShunzhou on 14-9-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseLogic.h"

@interface RLPersonLogic : RLBaseLogic


/**
 *  获得个人资料
 *
 *  @param username 手机号
 *  @param view     当前view
 *  @param success
 *  @param failure
 */
+(void)getPersonInfoWithUsername:(NSString*)username
                        withView:(UIView*)view
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(id responseObject))failure;



/**
 *  修改个人资料
 *
 *  @param username         用户名
 *  @param signature        个性签名
 *  @param gender           性别
 *  @param name             昵称
 *  @param birthday         生日
 *  @param locationId       地址ID
 *  @param locationName     地址
 *  @param friendValidation 好友验证方式 1、允许任何人 2、需要验证 3、不允许任何人
 *  @param visitPurview     动态访问权限 1、允许任何人 2、指定好友 3、好友可见
 *  @param view             当前view
 *  @param success
 *  @param failure          
 */
+(void)setPersonInfoWithUsername:(NSString*)username
                   withSignature:(NSString*)signature
                      withGender:(NSNumber*)gender
                        withName:(NSString*)name
                    withBirthday:(NSString*)birthday
                  withLocationId:(NSNumber*)locationId
                withLocationName:(NSString*)locationName
            withFriendValidation:(NSNumber*)friendValidation
                withVisitPurview:(NSNumber*)visitPurview
                        withView:(UIView*)view
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(id responseObject))failure;

/**
 *  设置头像
 *
 *  @param filePath 文件路径
 *  @param username 用户名
 *  @param view     当前view
 *  @param success
 *  @param failure
 */
+(void)setPhoto:(NSString *)filePath
   withUsername:(NSString *)username
       withView:(UIView*)view
        success:(void(^)(id responseObject))success
        failure:(void(^)(id responseObject))failure;

/**
 *  设置背景图
 *
 *  @param filePath 文件路径
 *  @param username 用户名
 *  @param view     当前view
 *  @param success
 *  @param failure
 */
+(void)setBackgroundImage:(NSString *)filePath
   withUsername:(NSString *)username
       withView:(UIView*)view
        success:(void(^)(id responseObject))success
        failure:(void(^)(id responseObject))failure;


/**
 *  修改密码
 *
 *  @param password 新密码
 *  @param oldPassword 老密码
 */
+(void)resetPassword:(NSString*)password
     withOldPassword:(NSString*)oldPassword
        withUsername:(NSString*)username
            withView:(UIView*)view
             success:(void(^)(id responseObject))success
             failure:(void(^)(id responseObject))failure;

/**
 *  下载文件到指定路径
 *
 *  @param filePath 本地路径
 *  @param urlStr   网络文件URL
 *  @param success
 *  @param failure
 */
+(void)download:(NSString *)filePath
        withURL:(NSString*)urlStr
        success:(void(^)(id response))success
        failure:(void(^)(NSError *error))failure;


@end
