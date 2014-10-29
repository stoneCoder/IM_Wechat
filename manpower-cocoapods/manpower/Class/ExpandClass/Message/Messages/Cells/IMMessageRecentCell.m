//
//  IMMessageRecentCell.m
//  manpower
//
//  Created by WangShunzhou on 14-6-24.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageRecentCell.h"
#import "IMMessageRecent.h"
#import "XMPPManager.h"
#import "RLFriend.h"
#import "RLRoom.h"

#define DEFAULT_PHOTO @"defaultPerson"
#define DEFAULT_GROUP_PHOTO @"defaultGroup"

@interface IMMessageRecentCell()

@property(nonatomic, assign) IBOutlet UIImageView *photoView;
@property(nonatomic, assign) IBOutlet UIImageView *numView;
@property(nonatomic, assign) IBOutlet UILabel *nicknameLabel;
@property(nonatomic, assign) IBOutlet UILabel *contentLabel;
@property(nonatomic, assign) IBOutlet UILabel *timeLabel;
@property(nonatomic, assign) IBOutlet UILabel *numLabel;

@end

@implementation IMMessageRecentCell

- (void)awakeFromNib
{
    self.photoView.layer.cornerRadius=self.photoView.frame.size.width/2;
    self.photoView.layer.masksToBounds=YES;
    
    self.numView.backgroundColor = [UIColor colorWithRed:1 green:0.5625 blue:0 alpha:1];
    self.numView.layer.cornerRadius=self.numView.frame.size.width/2;
    self.numView.layer.masksToBounds=YES;
    self.numView.layer.borderColor = [[UIColor colorWithWhite:1 alpha:1] CGColor];
    self.numView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithRecentMessage:(IMMessageRecent*)message{
    if (message.unreadMsgNum > 0) {
        self.numView.hidden = NO;
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)message.unreadMsgNum];
    }else{
        self.numView.hidden = YES;
        self.numLabel.hidden = YES;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:message.timestamp];
    __block UIImage *photoImage;
    
//    CGRect photoFrame = self.photoView.frame;
//    photoFrame.size = CGSizeMake(52, 52);
//    self.photoView.frame = photoFrame;
    if ([message.type  isEqualToString: @"chat"]) {
        /*
        XMPPJID *jid = [XMPPJID jidWithString:message.bareJID];
        self.photoView.image = photoImage = [UIImage imageNamed:DEFAULT_PHOTO];

        XMPPvCardAvatarModule *avatar = [XMPPManager sharedInstance].xmppvCardAvatarModule;
        
        NSData *photoData = nil;
        photoData = [avatar photoDataForJID:jid];
        if (photoData) {
            photoImage = [UIImage imageWithData:photoData];
            self.photoView.image = photoImage;
        }*/

        
//        __block NSData *photoData = nil;
//        __block UIImageView *blockIV = self.photoView;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            photoData = [avatar photoDataForJID:jid];
//            if (photoData) {
//                photoImage = [UIImage imageWithData:photoData];
//                blockIV.image = photoImage;
//            }
//        });
        
        RLFriend *friendInfo = [RLFriend MR_findFirstByAttribute:@"username" withValue:[[message.bareJID componentsSeparatedByString:@"@"] objectAtIndex:0]];
        NSURL *url = [NSURL URLWithString:friendInfo.photo];
        [self.photoView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
        
    }else if ([message.type isEqualToString:@"groupchat"]){
        RLRoom *room = [RLRoom MR_findFirstByAttribute:@"roomName" withValue:[[message.bareJID componentsSeparatedByString:@"@"] objectAtIndex:0]];
        photoImage = [UIImage imageNamed:DEFAULT_GROUP_PHOTO];
//        self.photoView.image = photoImage;
        NSURL *url = [NSURL URLWithString:room.photo];
        [self.photoView sd_setImageWithURL:url placeholderImage:photoImage];
    }
    
    NSString *nickname;
    
    if (message.nickname.length) {
        nickname = message.nickname;
    }else if([message.type isEqualToString:@"groupChat"]){
        NSString *roomName = [[message.bareJID componentsSeparatedByString:@"@"] objectAtIndex:0];
        nickname = roomName;
        __block IMMessageRecent* blockMessage = message;
        [RLRoom syncRoomWithRoomName:nickname success:^(NSString *roomNaturalName){
            blockMessage.nickname = roomNaturalName;
            [blockMessage save];
        } failure:NULL connectionError:NULL];
    }
    self.nicknameLabel.text = nickname;
    self.contentLabel.text = message.msg;
    self.timeLabel.text = timeStr;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
