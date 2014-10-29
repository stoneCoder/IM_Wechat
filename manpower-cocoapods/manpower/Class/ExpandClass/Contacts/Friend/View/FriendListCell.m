//
//  FriendListCell.m
//  manpower
//
//  Created by hanjin on 14-6-18.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "FriendListCell.h"
#import <CoreGraphics/CoreGraphics.h>
#import "RLFriend.h"
#import "RLPersonLogic.h"
#import "RLRoom.h"

@interface FriendListCell()
{
    __block RLFriend *friend;
    RLRoom *room;
}

@end

@implementation FriendListCell

- (void)awakeFromNib
{
    // Initialization code
    self.picImageView.layer.cornerRadius=self.picImageView.frame.size.width/2;
    self.picImageView.layer.masksToBounds=YES;
    self.selectImageView=[[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 18, 18)];
    [self.selectImageView setImage:[UIImage imageNamed:@"group_add"]];
    [self addSubview:self.selectImageView];
    self.selectImageView.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 更新cell
-(void)updateCellWithUserStorage:(XMPPUserCoreDataStorageObject *)aUser{
    friend = [RLFriend MR_findFirstByAttribute:@"username" withValue:aUser.jid.user];
    if (friend.remark.length) {
        self.nameLab.text=friend.remark;
    }else if (friend.name.length){
        self.nameLab.text=friend.name;
    }else {
        self.nameLab.text=aUser.jid.user;
    }
    
    [self configurePhotoWithUser:aUser];
}
-(void)updateGroupAddCellWithUserStorage:(XMPPUserCoreDataStorageObject *)aUser{
    
    self.isSelected=NO;
    self.selectImageView.hidden=NO;
    /*
    if (aUser.nickname) {
        self.nameLab.text=aUser.nickname;
    } else {
        self.nameLab.text=aUser.jid.user;
    }
    
    [self configurePhotoWithUser:aUser];
     */
    [self updateCellWithUserStorage:aUser];
}
-(void)updateCellWithGroupVO:(RLGroupVO *)rlGroupVO
{
    room = [RLRoom MR_findFirstByAttribute:@"roomName" withValue:rlGroupVO.roomName];
    self.nameLab.text = rlGroupVO.roomNaturalLanguageName;
    NSURL *url = [NSURL URLWithString:room.photo];
    [self.picImageView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
}

#pragma mark - 功能
/**
 *  功能:取头像
 */
- (void)configurePhotoWithUser:(XMPPUserCoreDataStorageObject *)user
{
    /*
    UIImage * picImg;
	if (user.photo != nil)
	{
		picImg =user.photo;
        
	}
	else
	{
		NSData *photoData = [[[XMPPManager sharedInstance] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			picImg =[UIImage imageWithData:photoData] ;
		else
			picImg = [UIImage imageNamed:@"defaultPerson"];
	}*/

    if (!friend || !friend.photo.length) {
        NSString *username = [user.jid user];
        @weakify(self);
        [RLPersonLogic getPersonInfoWithUsername:username withView:nil
                                         success:^(id responseObject){
                                             @strongify(self);
                                             friend = [RLFriend MR_findFirstByAttribute:@"username" withValue:username];
                                             if (!friend) {
                                                 friend = [RLFriend MR_createEntity];
                                             }
                                             if ([friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]]) {
                                                 [friend.managedObjectContext MR_saveOnlySelfAndWait];
                                                 [self showPhotoImageWithURLString:friend.photo withUser:user];
                                             }
                                         } failure:^(id json){
                                             DDLogVerbose(@"%@",json);
                                         }];
    }else{
        [self showPhotoImageWithURLString:friend.photo withUser:user];
    }

}

-(void)showPhotoImageWithURLString:(NSString*)urlString withUser:(XMPPUserCoreDataStorageObject*)user{
    NSURL *url = [NSURL URLWithString:urlString];
    @weakify(self);
    [self.picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultPerson"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        @strongify(self);
        if (image) {
            if (user.sectionNum.intValue==0 || user.sectionNum.intValue==1) {
                self.picImageView.image=image;
            } else {//离线
                self.picImageView.image=[self getGrayImage:image];
            }
        }
        /*
         else{
            @weakify(self);
            NSString * jidStr = [[user jid] user];
            [RLPersonLogic getPersonInfoWithUsername:jidStr withView:nil
                                             success:^(id responseObject){
                                                 @strongify(self);
                                                 RLFriend *friend = [RLFriend MR_findFirstByAttribute:@"jid" withValue:jidStr];
                                                 if (!friend) {
                                                     friend = [RLFriend MR_createEntity];
                                                 }
                                                 if ([friend MR_importValuesForKeysWithObject:[responseObject objectForKey:@"returnObj"]]) {
                                                     [friend.managedObjectContext MR_saveOnlySelfAndWait];
                                                     [self showPhotoImageWithURLString:friend.photo withUser:user];
                                                 }
                                             } failure:NULL];
        }*/
    }];

}

/**
 *  功能:离线时，图像置灰
 */

-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,(CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}
@end
