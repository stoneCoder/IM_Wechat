//
//  RLPerson.m
//  manpower
//
//  Created by WangShunzhou on 14-9-17.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFriend.h"
#import "RLPersonLogic.h"
#import "RLFriendLogic.h"

@implementation RLFriend

@dynamic age;
@dynamic background;
@dynamic birthday;
@dynamic jid;
@dynamic location;
@dynamic name;
@dynamic photo;
@dynamic sex;
@dynamic signature;
@dynamic username;
@dynamic remark;
@dynamic groups;
@dynamic subscription;
@dynamic online;

/*
-(void)setRemark:(NSString *)remark{
    [self willChangeValueForKey:@"remark"];
    [self setPrimitiveValue:remark.length ? remark : RAC_EMPTY_STRING forKey:@"remark"];
    [self didChangeValueForKey:@"remark"];
}

-(NSString*)remark{
    NSString *key = @"remark";
    [self willAccessValueForKey:key];
    NSString *retString = [self primitiveValueForKey:key];

    retString = [retString isEqualToString:RAC_EMPTY_STRING] ? @"" : retString;
    [self didAccessValueForKey:key];
    return retString;
}
*/
+(void)asyncFriendWidthJIDStr:(NSString*)jidStr{
    [RLPersonLogic getPersonInfoWithUsername:jidStr withView:nil
                                     success:^(id responseObject){
                                         RLFriend *friend = [RLFriend MR_findFirstByAttribute:@"jid" withValue:jidStr];
                                         if (!friend) {
                                             friend = [RLFriend MR_createEntity];
                                         }
                                         if ([friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]]) {
                                             DDLogVerbose(@"%@",friend);
                                             [friend.managedObjectContext MR_saveOnlySelfAndWait];
                                         }
                                     } failure:NULL];
    
}

-(NSString*)genderText{
    return [RLFriend genderText:self.sex];
}

+(NSString*)genderText:(NSNumber *)sex{
    NSString *gender;
    switch ([sex integerValue]) {
        case 0:
            gender = @"男";
            break;
            
        default:
            gender = @"女";
            break;
    }
    NSString *result = gender;
    return result;
}
@end
