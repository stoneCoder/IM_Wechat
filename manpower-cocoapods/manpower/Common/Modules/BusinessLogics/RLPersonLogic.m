//
//  RLPersonLogic.m
//  manpower
//
//  Created by WangShunzhou on 14-9-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLPersonLogic.h"
#import "DESUtil.h"

@implementation RLPersonLogic

+(void)getPersonInfoWithUsername:(NSString*)username withView:(UIView*)view success:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure{
    NSDictionary *params = @{@"ecOfuserRef.username":username};
    NSString *uri = @"findEcOfuserRefById";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

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
                         failure:(void(^)(id responseObject))failure{
    
    NSDictionary *params = @{@"ecOfuserRef.username":username,
                             @"ecOfuserRef.signature":signature,
                             @"ecOfuserRef.sex":gender,
                             @"ecOfuserRef.name":name,
                             @"ecOfuserRef.birthday":birthday,
                             @"ecOfuserRef.locationId":locationId,
                             @"ecOfuserRef.locationName":locationName,
                             @"ecOfuserRef.friendValidate":friendValidation,
                             @"ecOfuserRef.visitPurview":visitPurview,
                             };
    NSString *uri = @"addEcOfuserRef";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)uploadFile:(NSString *)filePath
          withURI:(NSString*)uri
     withFilename:(NSString*)filename
   withUsername:(NSString *)username
       withView:(UIView*)view
        success:(void(^)(id responseObject))success
        failure:(void(^)(id responseObject))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic uploadFile:filePath withFilename:filename withURL:urlStr Parameters:nil success:success failure:failure withView:view];
}

+(void)download:(NSString *)filePath
          withURL:(NSString*)urlStr
          success:(void(^)(id response))success
          failure:(void(^)(NSError *error))failure{
    [RLBaseLogic download:urlStr Parameters:nil filePath:filePath success:success failure:failure withView:nil];
}


+(void)setPhoto:(NSString *)filePath
   withUsername:(NSString *)username
       withView:(UIView*)view
        success:(void(^)(id responseObject))success
        failure:(void(^)(id responseObject))failure{
    NSDictionary *params = @{@"ecOfuserRef.username":username};
    
    NSString *filename = @"photoImage";
    NSString *uri = @"addEcOfuserRef";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    [RLPersonLogic uploadFile:filePath withFilename:filename withURL:urlStr Parameters:params success:success failure:failure withView:view];
}

+(void)setBackgroundImage:(NSString *)filePath
   withUsername:(NSString *)username
       withView:(UIView*)view
        success:(void(^)(id responseObject))success
        failure:(void(^)(id responseObject))failure{
    NSDictionary *params = @{@"ecOfuserRef.username":username};
    NSString *filename = @"backgroundImage";
    NSString *uri = @"addEcOfuserRef";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    [RLPersonLogic uploadFile:filePath withFilename:filename withURL:urlStr Parameters:params success:success failure:failure withView:view];
}


+(void)resetPassword:(NSString*)password
     withOldPassword:(NSString*)oldPassword
        withUsername:(NSString*)username
            withView:(UIView*)view
             success:(void(^)(id responseObject))success
             failure:(void(^)(id responseObject))failure{
    NSDictionary *params = @{@"ecModelValidate.model":username,
                             @"ecModelValidate.oldModelPwd":[DESUtil encrypt:oldPassword],
                             @"ecModelValidate.modelPwd":[DESUtil encrypt:password],
                             };
    NSString *uri = @"updateOfUserForPwd";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVICE_API,uri];
    
    [RLBaseLogic post:urlStr Parameters:params success:success failure:failure withView:view];
}
@end
