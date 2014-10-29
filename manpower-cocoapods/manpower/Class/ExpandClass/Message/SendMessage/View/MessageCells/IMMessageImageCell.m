//
//  IMMessageImageself.m
//  manpower
//
//  Created by WangShunzhou on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageImageCell.h"
#import "UIImageView+AFNetworking.h"
#define MSG_IMAGE_PLACEHOLDER @"msg_image_placeholder"

@interface IMMessageImageCell (){
    UITapGestureRecognizer *singleTap;
}

@end

@implementation IMMessageImageCell
@synthesize cachedImageDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[SWImageView alloc] initWithFrame:CGRectZero];
        self.imgView.backgroundColor = [UIColor clearColor];
        self.imgView.layer.cornerRadius = 4;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.activity setCenter:ccp(50,50)];
        

        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.percentLabel.backgroundColor = [UIColor clearColor];
        self.percentLabel.textColor = [UIColor grayColor];
        self.percentLabel.font = [UIFont systemFontOfSize:12];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
        self.maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.maskView.layer.cornerRadius = 4;
        self.maskView.layer.masksToBounds = YES;
        
        
        [self.containerView addSubview:self.imgView];
        [self.imgView addSubview:self.maskView];
        [self.maskView addSubview:self.activity];
        [self.maskView addSubview:self.percentLabel];
        
        cachedImageDic = [NSMutableDictionary dictionary];
//        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath{
    [self preConfigureCell:message];
    message.delegate = self;
    CGRect sentPhotoViewFrame = MSG_SENT_PHOTO_FRAME;
    CGRect recvPhotoViewFrame = MSG_RECV_PHOTO_FRAME;
    if (self.shouldShowTimeLabel) {
        sentPhotoViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
        recvPhotoViewFrame.origin.y += MSG_TIME_LABEL_HEIGHT;
    }
    
    CGFloat posY = MSG_CELL_TOP_PADDING;
    if (self.shouldShowTimeLabel) {
        posY += MSG_TIME_LABEL_HEIGHT;
    }
    CGRect containerFrame;
    if ([message isGroupChat]) {
        // 群聊天显示名字
        containerFrame = CGRectMake(MSG_IMAGE_MARGIN_H, posY + MSG_NICKNAME_LABEL_HEIGHT, 0, 0);
    }else{
        containerFrame = CGRectMake(MSG_IMAGE_MARGIN_H, posY, 0, 0);
    }
    
    UIImageView *photoView;
    SWImageView *imageView;
    UIView *containerView;
    
    // 取出photoView, textLabel, containerView
    photoView = self.photoView;
    imageView = self.imgView;
    containerView = self.containerView;
    [imageView setImage:nil];
    
    NSString *imageName = message.fileName;
    UIImage *localImage = nil;
    if ([cachedImageDic objectForKey:message.uuid]) {
        localImage = [cachedImageDic objectForKey:message.uuid];
    }else{
        localImage = [UIImage imageWithContentsOfFile:message.localFilePath];
        if (localImage && message.uuid.length) {
            [cachedImageDic setObject:localImage forKey:message.uuid];
        }
    }
    
    CGRect imageViewFrame = CGRectMake(MSG_IMAGE_MARGIN_H, MSG_IMAGE_MARGIN_V, 0, 0);
    
    if (localImage) {
        // 如果宽度宽了，宽度改成默认宽度。 高度缩放。
        if (localImage.size.width > MSG_IMAGE_DEFAULT_WIDTH) {
            imageViewFrame.size.width = MSG_IMAGE_DEFAULT_WIDTH;
            imageViewFrame.size.height = (MSG_IMAGE_DEFAULT_WIDTH / localImage.size.width) * localImage.size.height;
        }else{
            imageViewFrame.size = localImage.size;
        }
        // 如果高度高了，无视宽度，直接把高度调整为默认高度。
        if (imageViewFrame.size.height > MSG_IMAGE_DEFAULT_HEIGHT) {
            imageViewFrame.size.height = MSG_IMAGE_DEFAULT_HEIGHT;
        }
        [imageView setImage:localImage];
        
    }else{
        self.shouldUpdateWhileAttrChanged = NO;
        imageViewFrame.size.width = MSG_IMAGE_LOADING_WIDTH;
        imageViewFrame.size.height = MSG_IMAGE_LOADING_HEIGHT;
        UIImage *placeholderImage = [UIImage imageNamed:MSG_IMAGE_PLACEHOLDER];
        if (imageName.length == 0) {
            message.fileName = imageName = [[message.msg componentsSeparatedByString:@"/"] lastObject];
        }
        __block NSString *blockImageName = imageName;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:message.msg]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        DDLogVerbose(@"==================================");
        DDLogVerbose(@"imageView: %@",self.imgView);
        DDLogVerbose(@"==================================\n");
        __weak UIImageView *weakIV = imageView;
        __weak ZMMessage *msg = message;
        __weak IMMessageImageCell *cell = self;
        [imageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            DDLogVerbose(@"==================================");
            DDLogVerbose(@"weakIV: %@",weakIV);
            DDLogVerbose(@"==================================\n");
            weakIV.image = image;
            cell.shouldUpdateWhileAttrChanged = YES;
            msg.localFilePath = [IMMessageHelper saveImage:image withName:blockImageName];
            msg.status = MSG_STATUS_SUCCESS;
            [msg save];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            DDLogError(@"Load image failed:\n================\n %@",error);
        }];
    }
    
    if (message.outgoing) {
        containerFrame.origin.x = 320 - MSG_PHOTO_EDGE - 15 - imageViewFrame.size.width - MSG_IMAGE_MARGIN_H * 2 - 5;
//        containerFrame.size.width += 4;     // 加上一个宽度，远离泡泡的尖尖。
        imageViewFrame.origin.x -= 4;
//        [photoView setImage:myPhoto];
//        if (self.myInfo.localPhoto) {
//            [self.photoView setImage:[UIImage imageWithContentsOfFile:self.myInfo.localPhoto]];
//        }else{
            NSURL *url = [NSURL URLWithString:self.myInfo.photo];
            [self.photoView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
//        }
        [photoView setFrame:sentPhotoViewFrame];
        
        containerView.layer.borderColor = MSG_CONTAINER_BORDER_COLOR_SENT;
    }else{
        containerFrame.origin.x = MSG_RECV_CONTAINER_X;
//        containerFrame.size.width += 3;
        imageViewFrame.origin.x += 4;
        
//        [photoView setImage:friendPhoto];

        NSURL *url = [NSURL URLWithString:self.friendInfo.photo];
        [self.photoView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
        [photoView setFrame:recvPhotoViewFrame];
        
        containerView.layer.borderColor = MSG_CONTAINER_BORDER_COLOR_RECV;
    }
    [imageView setFrame:imageViewFrame];
    
    // 上传/下载中的遮罩
    if (message.status == MSG_STATUS_PENDING || MSG_STATUS_FAILURE) {
        [self.activity startAnimating];
        [self.maskView setFrame:CGRectMake(0, 0, imageViewFrame.size.width, imageViewFrame.size.height)];
        [self.activity setCenter:ccp(imageViewFrame.size.width * 0.5, imageViewFrame.size.height * 0.5)];
        
        // Todo 界面待调整
        CGRect rect = [self.activity frame];
        rect.origin.y += 25;
        self.percentLabel.frame = rect;
        self.percentLabel.hidden = NO;
    }else{
        [self.activity stopAnimating];
        [self.maskView setFrame:CGRectZero];
        self.percentLabel.hidden = YES;
    }
    
    containerFrame.size.height += MSG_IMAGE_MARGIN_V * 2 + imageView.frame.size.height;
    containerFrame.size.width += MSG_IMAGE_MARGIN_H * 2 + imageView.frame.size.width;
    [containerView setFrame:containerFrame];
    
    containerView.backgroundColor = [UIColor clearColor];
//    containerView.layer.borderWidth = 1;
    containerView.layer.cornerRadius = 5;
    containerView.layer.masksToBounds = YES;

    [super configureCell:message];

    if (localImage) {
        self.containerView.userInteractionEnabled = YES;
    }else{
        self.containerView.userInteractionEnabled = NO;
    }

}

-(void)iMMessage:(ZMMessage *)message uploadingImageWithPercentage:(NSString *)percentage{
    self.percentLabel.text = percentage;
}

@end
