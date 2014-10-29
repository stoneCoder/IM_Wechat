//
//  NotificationDataHelp.m
//  manpower
//
//  Created by hanjin on 14-6-18.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "NotificationDataHelp.h"
@implementation NotificationRequest
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.jid forKey:@"jid"];
    [aCoder encodeObject:self.myJid forKey:@"myJid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.dateStr forKey:@"dateStr"];
    [aCoder encodeObject:self.picImage forKey:@"picImage"];
    [aCoder encodeInt:self.requestType forKey:@"requestType"];
    [aCoder encodeInt:self.acceptedState forKey:@"acceptedState"];
    [aCoder encodeObject:self.reasonStr forKey:@"reasonStr"];
    [aCoder encodeObject:self.imageURLString forKey:@"imageURLString"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.jid=[aDecoder decodeObjectForKey:@"jid"];
    self.myJid=[aDecoder decodeObjectForKey:@"myJid"];
    self.name=[aDecoder decodeObjectForKey:@"name"];
    self.dateStr=[aDecoder decodeObjectForKey:@"dateStr"];
    self.picImage=[aDecoder decodeObjectForKey:@"picImage"];
    self.requestType=[aDecoder decodeIntForKey:@"requestType"];
    self.acceptedState=[aDecoder decodeIntForKey:@"acceptedState"];
    self.reasonStr=[aDecoder decodeObjectForKey:@"reasonStr"];
    self.imageURLString=[aDecoder decodeObjectForKey:@"imageURLString"];
    return self;
}
-(id)initWithJid:(XMPPJID *)aJid name:(NSString *)aName requestType:(int)aType acceptedState:(int)aState{
    self = [super init];
    if (self) {
        self.jid=aJid;
        self.myJid=[XMPPManager sharedInstance].xmppStream.myJID;
        self.name=aName;
        self.requestType=aType;
        self.acceptedState=aState;
    }
    return self;
}
-(BOOL)isEqualToNotificationRequest:(NotificationRequest *)aRequest{
    if ([aRequest.jid isEqualToJID:self.jid] && (aRequest.acceptedState ==self.acceptedState) && (aRequest.requestType==self.requestType) && ([aRequest.myJid isEqualToJID:self.myJid]) ) {
        return YES;
    }
    return NO;
}
@end
@implementation NotificationDataHelp
DEFINE_SINGLETON_FOR_CLASS(NotificationDataHelp)
-(NSMutableArray *)currentNotificationList{
    NSMutableArray * ary=[NSKeyedUnarchiver unarchiveObjectWithFile:ac_PathInCachesDirectory(MESSAGE_NOTIFICATION)];
    NSMutableArray * curentAry=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        NotificationRequest * request=[ary objectAtIndex:i];
        if ([request.myJid isEqual:[XMPPManager sharedInstance].xmppStream.myJID]) {
            [curentAry addObject:request];
        }
    }
    
    return  curentAry;
}
-(void)saveNotificationList:(NSMutableArray *)ary{
   [NSKeyedArchiver archiveRootObject:ary toFile:ac_PathInCachesDirectory(MESSAGE_NOTIFICATION)];
}
-(void)saveNotificationRequest:(NotificationRequest *)aRequest{
    NSDate * date=[NSDate date];
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm"];
    aRequest.dateStr=[dateFormatter stringFromDate:date];
    NSMutableArray * ary=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:ac_PathInCachesDirectory(MESSAGE_NOTIFICATION)];
    if (ary && ary.count>0) {
        for (int i=0; i<ary.count; i++) {
            NotificationRequest * request=[ary objectAtIndex:i];
            if ([request  isEqualToNotificationRequest:aRequest]) {
                            [ary removeObject:request];
            }
        }
    }else{
        ary=[[NSMutableArray alloc]init];
    }
    [ary insertObject:aRequest atIndex:0];
    [self saveNotificationList:ary];
}

-(int)currentNotificationBadgeNum{
   return  [[NSUserDefaults standardUserDefaults] integerForKey:MESSAGE_NOTIFICATION_NUM_BADGE];
}
-(void)saveNotificationBadgeNum:(int)aNum{
    [[NSUserDefaults standardUserDefaults] setInteger:aNum forKey:MESSAGE_NOTIFICATION_NUM_BADGE];
}
@end
