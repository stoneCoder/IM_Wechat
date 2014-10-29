//
//  RLMyInfo.h
//  manpower
//
//  Created by WangShunzhou on 14-6-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPJID;
@interface RLMyInfo : NSObject
DEFINE_SINGLETON_FOR_HEADER(RLMyInfo)

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * localPhoto;
@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSString * localBackground;
@property (nonatomic, retain) NSString * locationName;

@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSNumber * friendValidate;
@property (nonatomic, retain) NSNumber * visitPurview;
@property (nonatomic, retain) NSNumber * sex;

@property (nonatomic, retain) NSNumber * creationDate;
@property (nonatomic, retain) NSNumber * modificationDate;
@property (nonatomic, retain) NSString * registrationDate;

@property (nonatomic) BOOL shouldFillInfo;
@property (nonatomic) BOOL shouldChangePhoto;
@property (nonatomic) BOOL shouldChangeBackground;

//@property (nonatomic) NSInteger locationId;
//@property (nonatomic) NSInteger friendValidate;
//@property (nonatomic) NSInteger visitPurview;
//@property (nonatomic) NSInteger sex;

-(void)loadUserData;
-(void)saveUserData;
-(void)getUserInfoFromServer:(void(^)(BOOL success))completion;
-(void)updateInfo;
-(void)updateInfoWithSuccess:(void(^)(id responseObject))success failure:(void(^)(id responseObject))failure;

-(void)updatePassword:(NSString*)password
      withOldPassword:(NSString*)oldPassword
             withView:(UIView*)view
              success:(void(^)(id responseObject))success;

-(void)downloadPhotoWithSuccess:(void(^)(id response))success
                        failure:(void(^)(NSError *error))failure;
-(void)downloadBackgroundWithSuccess:(void(^)(id response))success
                             failure:(void(^)(NSError *error))failure;
-(void)updatePhoto;
-(void)updateBackground;

-(void)clear;
@end