//
//  IMMessage.h
//  manpower
//
//  Created by WangShunzhou on 14-6-17.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPCoreDataStorage.h"
#import "ZMMessage.h"
@class IMMessageRecent;
@class XMPPMessageArchiving_Message_CoreDataObject;

@interface IMMessageStorage : XMPPCoreDataStorage<NSFetchedResultsControllerDelegate>{
//    ZMMessage *imMessage;
    NSFetchedResultsController *fetchedResultsController;
    NSString *bareJID;
}
@property(nonatomic,strong) NSString *bareJID;

+ (instancetype)sharedInstance;
-(ZMMessage*)insertIMMessage:(XMPPMessageArchiving_Message_CoreDataObject*)message;
-(ZMMessage*)insertIMMessage;
-(ZMMessage*)insertChatIMMessage;
-(ZMMessage*)insertGroupchatIMMessage;

-(BOOL)removeRecentMessageWithBareJID:(NSString*)bareJID;
-(BOOL)removeMessageWithBareJID:(NSString*)aBareJID;
@end
