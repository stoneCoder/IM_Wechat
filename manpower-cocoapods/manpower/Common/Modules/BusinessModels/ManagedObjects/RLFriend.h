//
//  RLPerson.h
//  manpower
//
//  Created by WangShunzhou on 14-9-17.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RLFriend: NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * jid;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * groups;
@property (nonatomic, retain) NSNumber * subscription;
@property (nonatomic, retain) NSNumber * online;


+(void)asyncFriendWidthJIDStr:(NSString*)jidStr;
-(NSString*)genderText;
+(NSString*)genderText:(NSNumber*)sex;
@end
