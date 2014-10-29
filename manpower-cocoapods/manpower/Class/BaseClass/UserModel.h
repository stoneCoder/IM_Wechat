//
//  UserModel.h
//  Cntianran
//
//  Created by Brian on 14-9-2.
//  Copyright (c) 2014年 INMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
DEFINE_SINGLETON_FOR_HEADER(UserModel)
- (NSMutableArray *)getUserList;
- (void)saveUserList:(NSMutableArray *)userList;
- (void)updateUserList:(NSMutableArray *)userList;
@end
