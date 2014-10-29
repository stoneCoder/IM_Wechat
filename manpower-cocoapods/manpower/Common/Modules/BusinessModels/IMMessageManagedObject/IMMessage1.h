//
//  IMMessage.h
//  manpower
//
//  Created by WangShunzhou on 14-6-17.
//  Copyright (c) 2014年 hanjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class XMPPMessageArchiving_Message_CoreDataObject;
@class XMPPJID;
@protocol IMMessageDelegate;

@interface IMMessage : NSManagedObject<NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSString * uuid;

@property (nonatomic, retain) NSString * fromJID;

@property (nonatomic, retain) NSString * fromBareJID;

@property (nonatomic, retain) NSString * toJID;

@property (nonatomic, retain) NSString *toBareJID;

@property (nonatomic, retain) NSString * toConversationJID;

@property (nonatomic, retain) NSString * desc;

@property (nonatomic, retain) NSString * msg;

//@property (nonatomic, retain) NSNumber * msgType;

@property (nonatomic, assign) NSInteger msgType;

//@property (nonatomic, retain) NSNumber * outgoing;
@property (nonatomic) BOOL outgoing;

@property (nonatomic, retain) NSDate * timestamp;

@property (nonatomic, retain) NSDate * remoteTimestamp;

@property (nonatomic, retain) NSDate * sendTime;

@property (nonatomic, retain) NSString * type;

@property (nonatomic, retain) NSString * localFilePath;

@property (nonatomic, retain) NSString * fileName;

@property (nonatomic, retain) NSString * friendBareJID;

@property (nonatomic, retain) NSString * myBareJID;

@property (nonatomic, retain) NSString * roomJID;

@property (nonatomic, retain) NSString * nickname;

//@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic) BOOL unread;

@property (nonatomic) NSInteger status; //0:失败, 1:成功, 2:发送/接收中

@property (nonatomic, assign) id<IMMessageDelegate> delegate;

-(void)sendImage:(UIImage*)image withParameters:(NSDictionary*)parameters;
-(void)sendVoice:(NSString*)filePath withParameters:(NSDictionary*)parameters;
-(void)sendText:(NSString*)text;
-(void)sendMessage:(NSInteger)msgType withGroupchatType:(NSString*)type fromJID:(XMPPJID*)fromJID toJID:(XMPPJID*)toJID withAttachment:(id)attachment;

-(void)sendXMPPMessage:(NSDictionary*)bodyDic;
-(BOOL)save;
-(void)afterMessageSent;

-(CGFloat)getRowHeight:(BOOL)showTimeLabel;

-(BOOL)isGroupChat;
-(BOOL)isChat;

-(void)getMessage:(NSString*)message withArray:(NSMutableArray*)array;
- (CGSize)getContentSize;

-(void)setupCryptProperties;
@end



@protocol IMMessageDelegate <NSObject>
@optional
-(void)iMMessage:(IMMessage*)message uploadingImageWithPercentage:(NSString*)percentage;
-(void)iMMessage:(IMMessage*)message uploadingVoiceWithPercentage:(NSString*)percentage;
@end