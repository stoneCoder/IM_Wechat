//
//  RLRegisterLogic.m
//  manpower
//
//  Created by WangShunzhou on 14-9-11.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLRegisterLogic.h"
#import "DESUtil.h"

@implementation RLRegisterLogic

+(void)getCaptchaForRegisterWithPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view{
    NSDictionary *params = @{@"ecModelValidate.model":phoneNumber};
    NSString *uri = @"addEcModelValidate";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)getCaptchaForResetPasswordWithPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view{
    NSDictionary *params = @{@"ecModelValidate.model":phoneNumber};
    NSString *uri = @"addEcModelValidateForUpdate";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)confirmCaptcha:(NSString*)captcha withPhoneNumber:(NSString*)phoneNumber success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure withView:(UIView*)view{
    NSDictionary *params = @{@"ecModelValidate.model":phoneNumber,
                             @"ecModelValidate.validateCode":captcha};
    NSString *uri = @"mobileValidateStep1";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)registerWithPhoneNumber:(NSString*)phoneNumber withCaptcha:(NSString*)captcha withPassword:(NSString*)password withCurrentView:(UIView*)view success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure {
    NSDictionary *params = @{@"ecModelValidate.model":phoneNumber,
                             @"ecModelValidate.validateCode":captcha,
                             @"ecModelValidate.modelPwd":[DESUtil encrypt:password]};
    NSString *uri = @"addOfUserForRegisterStep2";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)resetPasswordWithPhoneNumber:(NSString*)phoneNumber withCaptcha:(NSString*)captcha withPassword:(NSString*)password withCurrentView:(UIView*)view success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure {
    NSDictionary *params = @{@"ecModelValidate.model":phoneNumber,
                             @"ecModelValidate.validateCode":captcha,
                             @"ecModelValidate.modelPwd":[DESUtil encrypt:password]};
    
    NSString *uri = @"updateOfUserForForget";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

@end
