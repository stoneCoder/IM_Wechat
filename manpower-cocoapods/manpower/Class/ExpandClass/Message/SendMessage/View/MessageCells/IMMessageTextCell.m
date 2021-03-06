//
//  IMMessageTextself.m
//  manpower
//
//  Created by WangShunzhou on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageTextCell.h"
#import "ZMMessage.h"
#import "UIImage+SWImage.h"
#import "TextMessageView.h"

@implementation IMMessageTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.txtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.txtLabel.backgroundColor = [UIColor clearColor];
//        self.txtLabel.numberOfLines = 0;
//        self.txtLabel.font = [UIFont systemFontOfSize:MSG_FONT_SIZE];
//        self.txtLabel.textAlignment = NSTextAlignmentJustified;
//        self.txtLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
//        [self addSubview:self.txtLabel];
        
        self.msgView = [[TextMessageView alloc] initWithFrame:CGRectZero];
        [self.containerView addSubview:self.msgView];
    }
    return self;
}

-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath{
    [self preConfigureCell:message];
    
    CGRect sentPhotoViewFrame = MSG_SENT_PHOTO_FRAME;
    CGRect sentTextLabelFrame = CGRectMake(MSG_SENT_CONTAINER_X + MSG_TEXT_MARGIN_H, MSG_CELL_TOP_PADDING + MSG_TEXT_MARGIN_V, MSG_CONTENT_MAX_WIDTH - MSG_TEXT_MARGIN_H * 2 - MSG_BUBBLE_LENGTH, MSG_PHOTO_EDGE);
    CGRect sentContainerViewFrame = CGRectMake(MSG_SENT_CONTAINER_X, MSG_CELL_TOP_PADDING, MSG_CONTENT_MAX_WIDTH, MSG_PHOTO_EDGE);

    CGRect recvPhotoViewFrame = MSG_RECV_PHOTO_FRAME;
    CGRect recvTextLabelFrame = CGRectMake(MSG_RECV_CONTAINER_X + MSG_TEXT_MARGIN_H + MSG_BUBBLE_LENGTH, MSG_CELL_TOP_PADDING + MSG_TEXT_MARGIN_V, MSG_CONTENT_MAX_WIDTH - MSG_TEXT_MARGIN_H * 2 - MSG_BUBBLE_LENGTH, MSG_PHOTO_EDGE);
    CGRect recvContainerViewFrame = CGRectMake(MSG_RECV_CONTAINER_X, MSG_CELL_TOP_PADDING, MSG_CONTENT_MAX_WIDTH, MSG_PHOTO_EDGE);

    if (self.shouldShowTimeLabel) {
        sentPhotoViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        sentTextLabelFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        sentContainerViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        
        recvPhotoViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        recvTextLabelFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        recvContainerViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
    }
    
    if ([message isGroupChat]) {
        sentTextLabelFrame.origin.y += MSG_NICKNAME_LABEL_HEIGHT;
        sentContainerViewFrame.origin.y += MSG_NICKNAME_LABEL_HEIGHT;
        
        recvTextLabelFrame.origin.y += MSG_NICKNAME_LABEL_HEIGHT;
        recvContainerViewFrame.origin.y += MSG_NICKNAME_LABEL_HEIGHT;
    }
//    [self setFrame:CGRectMake(0, 0, 320, 54)];
    self.containerView.layer.cornerRadius = 5;
//    self.containerView.layer.borderWidth = 1;

    CGSize size = [message getContentSize];
    
    NSMutableArray *msgArr = [NSMutableArray array];
    [message getMessage:message.msg withArray:msgArr];
//    DDLogVerbose(@"%@",msgArr);

    [self.msgView showMessage:msgArr];
    

    int bubbleAngleLength = MSG_BUBBLE_LENGTH;

    if (message.outgoing) { //发送信息
        
//        [self.photoView setImage:myPhoto];
//        if (self.myInfo.localPhoto) {
//            [self.photoView setImage:[UIImage imageWithContentsOfFile:self.myInfo.localPhoto]];
//        }else{
            NSURL *url = [NSURL URLWithString:self.myInfo.photo];
            [self.photoView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
//        }
        
        [self.photoView setFrame:sentPhotoViewFrame];
        
        [self.msgView setFrame:sentTextLabelFrame];
        
        [self.containerView setFrame:sentContainerViewFrame];
        self.containerView.layer.borderColor = [[UIColor colorWithRed:0.2 green:0.9 blue:0.3 alpha:1] CGColor];
        
        // 设置container的Frame
        CGRect containerViewFrame = self.containerView.frame;
        containerViewFrame.size.width = size.width + MSG_TEXT_MARGIN_H * 2 + bubbleAngleLength;
        containerViewFrame.size.height = size.height + MSG_TEXT_MARGIN_V * 2;
        containerViewFrame.origin.x = MSG_SENT_PHOTO_X - containerViewFrame.size.width - 10;
        self.containerView.frame = containerViewFrame;
        self.msgView.frame = CGRectMake(MSG_TEXT_MARGIN_H,MSG_TEXT_MARGIN_V, size.width, size.height);


    }else{  // 接收信息
        
//        [self.photoView setImage:friendPhoto];
        if ([message isChat]) {
            NSURL *url = [NSURL URLWithString:self.friendInfo.photo];
            [self.photoView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
        }
        [self.photoView setFrame:recvPhotoViewFrame];
        [self.msgView setFrame:recvTextLabelFrame];
        
        [self.containerView setFrame:recvContainerViewFrame];
        self.containerView.layer.borderColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor];
        
        CGRect containerViewFrame = self.containerView.frame;
        containerViewFrame.origin.x = MSG_RECV_CONTAINER_X;

        containerViewFrame.size.width = size.width + MSG_TEXT_MARGIN_H * 2 + bubbleAngleLength;
        containerViewFrame.size.height = size.height + MSG_TEXT_MARGIN_V * 2;
        self.containerView.frame = containerViewFrame;
        self.msgView.frame = CGRectMake(MSG_TEXT_MARGIN_H+bubbleAngleLength,MSG_TEXT_MARGIN_V, size.width, size.height);
    }
    
    [super configureCell:message];
}

/*
-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath{
    [self preConfigureCell:message];
    
    CGRect sentPhotoViewFrame = MSG_SENT_PHOTO_FRAME;
    CGRect sentTextLabelFrame = CGRectMake(MSG_SENT_CONTAINER_X + MSG_TEXT_MARGIN_H, MSG_CELL_TOP_PADDING + MSG_TEXT_MARGIN_V, MSG_CONTENT_MAX_WIDTH - MSG_TEXT_MARGIN_H * 2 - MSG_BUBBLE_LENGTH, MSG_PHOTO_EDGE);
    CGRect sentContainerViewFrame = CGRectMake(MSG_SENT_CONTAINER_X, MSG_CELL_TOP_PADDING, MSG_CONTENT_MAX_WIDTH, MSG_PHOTO_EDGE);
    
    CGRect recvPhotoViewFrame = MSG_RECV_PHOTO_FRAME;
    CGRect recvTextLabelFrame = CGRectMake(MSG_RECV_CONTAINER_X + MSG_TEXT_MARGIN_H + MSG_BUBBLE_LENGTH, MSG_CELL_TOP_PADDING + MSG_TEXT_MARGIN_V, MSG_CONTENT_MAX_WIDTH - MSG_TEXT_MARGIN_H * 2 - MSG_BUBBLE_LENGTH, MSG_PHOTO_EDGE);
    CGRect recvContainerViewFrame = CGRectMake(MSG_RECV_CONTAINER_X, MSG_CELL_TOP_PADDING, MSG_CONTENT_MAX_WIDTH, MSG_PHOTO_EDGE);
    
    [self setFrame:CGRectMake(0, 0, 320, 54)];
    self.containerView.layer.cornerRadius = 5;
    //    self.containerView.layer.borderWidth = 1;
    
    CGSize size = [message.msg sizeWithFont:[UIFont systemFontOfSize:MSG_FONT_SIZE]];
    
    self.txtLabel.text = message.msg;
    self.txtLabel.numberOfLines = 0;
    //    self.txtLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    if (message.outgoing) { //发送信息
        
        [self.photoView setImage:myPhoto];
        [self.photoView setFrame:sentPhotoViewFrame];
        
        [self.txtLabel setFrame:sentTextLabelFrame];
        
        [self.containerView setFrame:sentContainerViewFrame];
        self.containerView.layer.borderColor = [[UIColor colorWithRed:0.2 green:0.9 blue:0.3 alpha:1] CGColor];
        int bubbleAngleLength = MSG_BUBBLE_LENGTH;
        if (size.width + bubbleAngleLength < MSG_CONTENT_MAX_WIDTH) {    // 定高，一行文本。 +10为发消息多出来的那个尖尖。
            self.txtLabel.frame = CGRectMake(320 - MSG_PHOTO_EDGE - 20 - 5 - (size.width + bubbleAngleLength), (self.containerView.frame.size.height - size.height) * 0.5 + MSG_CELL_TOP_PADDING, size.width, size.height);
            CGRect containerViewFrame = self.containerView.frame;
            containerViewFrame.origin.x = self.txtLabel.frame.origin.x - MSG_TEXT_MARGIN_H;
            containerViewFrame.size.width = self.txtLabel.frame.size.width + MSG_TEXT_MARGIN_H * 2 + bubbleAngleLength;
            self.containerView.frame = containerViewFrame;
        }else{      // 定宽，多行文本
            [self.txtLabel sizeToFit];
            CGRect txtLabelFrame = self.txtLabel.frame;
            CGRect containerViewFrame = self.containerView.frame;
            containerViewFrame.size.height = txtLabelFrame.size.height + MSG_TEXT_MARGIN_V * 2;
            self.containerView.frame = containerViewFrame;
        }
        
    }else{  // 接收信息
        
        [self.photoView setImage:friendPhoto];
        
        [self.photoView setFrame:recvPhotoViewFrame];
        
        [self.txtLabel setFrame:recvTextLabelFrame];
        
        [self.containerView setFrame:recvContainerViewFrame];
        self.containerView.layer.borderColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor];
        
        if (size.width < MSG_CONTENT_MAX_WIDTH) {
            self.txtLabel.frame = CGRectMake(MSG_RECV_CONTAINER_X + MSG_TEXT_MARGIN_H + 5, (self.containerView.frame.size.height - size.height) * 0.5 + MSG_CELL_TOP_PADDING, size.width, size.height);
            CGRect containerViewFrame = self.containerView.frame;
            containerViewFrame.size.width = self.txtLabel.frame.size.width + MSG_TEXT_MARGIN_H * 2;
            self.containerView.frame = containerViewFrame;
        }else{
            [self.txtLabel sizeToFit];
            CGRect txtLabelFrame = self.txtLabel.frame;
            CGRect containerViewFrame = self.containerView.frame;
            containerViewFrame.size.height = txtLabelFrame.size.height + MSG_TEXT_MARGIN_V * 2;
            self.containerView.frame = containerViewFrame;
        }
    }
    
    [super configureCell:message];
}
*/
@end
