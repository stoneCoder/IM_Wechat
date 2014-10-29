//
//  RLRegisterLogic.h
//  manpower
//
//  Created by WangShunzhou on 14-9-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLBaseLogic.h"

@interface RLRegisterLogic : RLBaseLogic
/**
 *  注册时，获取验证码
 *
 *  @param phoneNumber 手机号
 *  @param success     success
 *  @param failure     failure
 *  @param view        当前view
 */
+(void)getCaptchaForRegisterWithPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view;

/**
 *  重置密码时，获取验证码
 *
 *  @param phoneNumber 手机号
 *  @param success     success
 *  @param failure     failure
 *  @param view        当前view
 */
+(void)getCaptchaForResetPasswordWithPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view;

/**
 *  验证验证码
 *
 *  @param captcha     验证码
 *  @param phoneNumber 手机号
 *  @param success     success
 *  @param failure     failure
 *  @param view        当前view
 */
+(void)confirmCaptcha:(NSString*)captcha withPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view;


/**
 *  注册IM用户
 *
 *  @param phoneNumber 手机号
 *  @param captcha     验证码
 *  @param password    密码
 *  @param view        当前view
 *  @param success     success
 *  @param failure     failure
 */
+(void)registerWithPhoneNumber:(NSString*)phoneNumber withCaptcha:(NSString*)captcha withPassword:(NSString*)password withCurrentView:(UIView*)view success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure;

/**
 *  重置密码，最后一步。
 *
 *  @param phoneNumber 手机号
 *  @param captcha     验证码
 *  @param password    密码
 *  @param view        当前view
 *  @param success     success
 *  @param failure     failure
 */
+(void)resetPasswordWithPhoneNumber:(NSString*)phoneNumber withCaptcha:(NSString*)captcha withPassword:(NSString*)password withCurrentView:(UIView*)view success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure;

@end
