//
//  AddFriendListCell.m
//  manpower
//
//  Created by WangShunzhou on 14-9-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "AddFriendListCell.h"

@implementation AddFriendListCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width * 0.5;
    //        cell.imageView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(NSDictionary*)dic{
    NSURL *url = [dic objectForKey:@"photo"];
    NSString *fullname = [dic objectForKey:@"name"];
    
    [self.photoImageView sd_setImageWithURL:url placeholderImage:IMAGE_DEFAULT_PERSON];
//    [self.photoImageView setImage:IMAGE_DEFAULT_PERSON];
    self.nameLabel.text = fullname;
}

@end
