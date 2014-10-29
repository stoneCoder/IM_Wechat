//
//  UserModel.m
//  Cntianran
//
//  Created by Brian on 14-9-2.
//  Copyright (c) 2014年 INMEDIA. All rights reserved.
//

#import "UserModel.h"

#define SERVICE_NAME @"xIM"

@implementation UserModel
DEFINE_SINGLETON_FOR_CLASS(UserModel)
- (NSString*)documentDirectory

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString*)userListFilename
{
    NSString *path = [[self documentDirectory] stringByAppendingPathComponent:@"user_list"];
    NSLog(@"%@", path);
    return path;
}

-(NSMutableArray *)getUserList
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self userListFilename]];
}

- (void)saveUserList:(NSMutableArray *)userList
{
    [NSKeyedArchiver archiveRootObject:userList toFile:[self userListFilename]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateUserList:(NSMutableArray *)userList
{
    /*获取已存列表*/
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self userListFilename]];
    if (array.count > RECORD_COUNT) {
        [array removeLastObject];
    }
    if (array) {
        if ([userList count] > 0) {
            userList = [self removeExitsObject:array andResult:userList];
        }else
        {
            [userList removeAllObjects];
        }
    }else
    {
        [userList addObjectsFromArray:array];
    }
    [self saveUserList:userList];
}

-(NSMutableArray *)removeExitsObject:(NSMutableArray *)array andResult:(NSMutableArray *)data
{
    for (int i = 0; i < array.count; i++) {
        NSString *exitsStr = array[i];
        for (int j = 0; j < data.count; j++) {
            if ([data[j] isEqualToString:exitsStr]) {
                [array removeObjectAtIndex:i];
            }
        }
    }
    [data addObjectsFromArray:array];
    return data;
}
@end
