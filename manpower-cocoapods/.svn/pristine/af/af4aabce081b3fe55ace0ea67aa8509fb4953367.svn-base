//
//  RLGroupVO.m
//  manpower
//
//  Created by hanjin on 14-6-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLGroupVO.h"
#import "RLRoom.h"
#import "RLRoomLogic.h"
#import "XMPPManager.h"

@implementation RLGroupVO

-(void)save{
    RLRoom *room = [RLRoom MR_findFirstByAttribute:@"roomName" withValue:self.roomName];
    if (room == nil) {
//        room = [RLRoom MR_createEntity];
        return;
    }
    [room MR_importValuesForKeysWithObject:self];
    [room.managedObjectContext MR_saveOnlySelfAndWait];
}

-(void)update{
    [self updateWithView:nil success:NULL failure:NULL];
}

-(void)updateWithView:(UIView*)view
              success:(void(^)(id responseObject))success
              failure:(void(^)(id responseObject))failure{
    @weakify(self);
    [RLRoomLogic updateRoom:self.roomName
                withUserJID:[XMPPManager sharedInstance].xmppStream.myJID.bare
            withDescription:self.roomDescription
                withSubject:self.roomSubject
            withNaturalName:self.roomNaturalLanguageName
                   withView:view success:^(id responseObject){
                       if (success) {
                           success(responseObject);
                       }
                       @strongify(self);
                       [self save];
                   } failure:failure];
}
@end
